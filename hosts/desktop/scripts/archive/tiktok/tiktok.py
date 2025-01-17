from TikTokApi import TikTokApi
import asyncio
import os
import sys

SCROLL_TIMEOUT = 3000
TIKTOK_MS_TOKEN = os.environ.get("TIKTOK_MS_TOKEN", None)


async def continue_as_guest(page):
    continue_button = page.get_by_role("link", name="Continue as guest")
    if (await continue_button.is_visible()): await continue_button.click()

    while not (await page.is_visible("[data-e2e=\"user-post-item-list\"]")):
        refresh_button = page.get_by_role("button", name="Refresh")
        if (await refresh_button.is_visible()): await refresh_button.click()
        else: await page.wait_for_timeout(1000)

async def scroll_to_bottom(page):
    prev_height = None
    curr_height = None

    while True:
        curr_height = await page.evaluate("(window.innerHeight + window.scrollY)")
        if curr_height != None and curr_height == prev_height: break

        await page.mouse.wheel(0, 9999999)
        await page.wait_for_timeout(SCROLL_TIMEOUT)
        prev_height = curr_height

async def get_user_video_urls(username, page):
    return await page.evaluate(f"Array.from(new Set(Array.from(document.links).filter((l) => l.href?.startsWith(`https://www.tiktok.com/@{username}/video`)).map(x => x.href)))")

async def download_videos(username):
    async with TikTokApi() as api:
        await api.create_sessions(
            ms_tokens=[TIKTOK_MS_TOKEN],
            num_sessions=1,
            sleep_after=3,
            headless=False,
            starting_url=f"https://tiktok.com/@{username}",
            browser="webkit"
        )
        page = api.sessions[0].page
        await page.wait_for_timeout(5000)
        await continue_as_guest(page)
        await scroll_to_bottom(page)
        urls = await get_user_video_urls(username, page)
        print('\n'.join(urls))

if __name__ == "__main__":
    asyncio.run(download_videos(username=sys.argv[1]))
