#! /usr/bin/env fish

argparse --name=archive --min-args=1 's/site=' 'd/dest=' -- $argv
or return

function anime_artist --argument-names username url
  echo gallery-dl -d "$ARCHIVE_DIR/anime/artists/$username" $url
  gallery-dl -d "$ARCHIVE_DIR/anime/artists/$username" $url
end

function instagram_user --argument-names dest username
  if test -n $dest
    echo gallery-dl https://instagram.com/$username -d "$ARCHIVE_DIR/irl/instagram/$dest"
    gallery-dl https://instagram.com/$username -d "$ARCHIVE_DIR/irl/instagram/$dest"
  else 
    echo gallery-dl https://instagram.com/$username -d "$ARCHIVE_DIR/irl/instagram/$username"
    gallery-dl https://instagram.com/$username -d "$ARCHIVE_DIR/irl/instagram/$username"
  end
end

function reddit_user --argument-names dest username
  if test -n $dest
    echo gallery-dl https://reddit.com/user/$username -d "$ARCHIVE_DIR/irl/reddit/$dest"
    gallery-dl https://reddit.com/user/$username -d "$ARCHIVE_DIR/irl/reddit/$dest"
  else 
    echo gallery-dl https://reddit.com/user/$username -d "$ARCHIVE_DIR/irl/reddit/$username"
    gallery-dl https://reddit.com/user/$username -d "$ARCHIVE_DIR/irl/reddit/$username"
  end
end

function tiktok_user --argument-names dest username file
  # manual method:
  # copy(Array.from(new Set(Array.from(document.links).filter((l) => l.href?.startsWith(`${window.location.href.split('?')[0]}/video`)).map(x => x.href))).join('\n'))
  # archive -s tiktok $username ./urls.txt
  set video_urls (__get_tiktok_user_video_urls $username; or cat $file)

  for url in $video_urls
    if test -n $dest
      echo yt-dlp -P "$ARCHIVE_DIR/irl/tiktok/$dest" -o "%(upload_date)s - %(id)s.%(ext)s" $url
      yt-dlp -P "$ARCHIVE_DIR/irl/tiktok/$dest" -o "%(upload_date)s - %(id)s.%(ext)s" $url
    else
      echo yt-dlp -P "$ARCHIVE_DIR/irl/tiktok/$username" -o "%(upload_date)s - %(id)s.%(ext)s" $url
      yt-dlp -P "$ARCHIVE_DIR/irl/tiktok/$username" -o "%(upload_date)s - %(id)s.%(ext)s" $url
    end
  end
end

function twitter_user --argument-names dest username
  if test -n $dest
    echo gallery-dl https://twitter.com/$username -d "$ARCHIVE_DIR/irl/twitter/$dest"
    gallery-dl https://twitter.com/$username -d "$ARCHIVE_DIR/irl/twitter/$dest"
  else 
    echo gallery-dl https://twitter.com/$username -d "$ARCHIVE_DIR/irl/twitter/$username"
    gallery-dl https://twitter.com/$username -d "$ARCHIVE_DIR/irl/twitter/$username"
  end
end

function youtube_channel --argument-names dest username
  if test -n $dest
    echo yt-dlp https://youtube.com/@$username -P "$ARCHIVE_DIR/irl/youtube/$dest"
    yt-dlp https://youtube.com/@$username -P "$ARCHIVE_DIR/irl/youtube/$dest"
  else 
    echo yt-dlp https://youtube.com/@$username -P "$ARCHIVE_DIR/irl/youtube/$username"
    yt-dlp https://youtube.com/@$username -P "$ARCHIVE_DIR/irl/youtube/$username"
  end
end

switch $_flag_site
  case artist
    anime_artist $argv
  case instagram
    instagram_user "$_flag_dest" $argv
  case reddit
    reddit_user "$_flag_dest" $argv
  case tiktok
    tiktok_user "$_flag_dest" $argv
  case twitter
    twitter_user "$_flag_dest" $argv
  case youtube
    youtube_channel "$_flag_dest" $argv
  case '*'
    echo Valid sites: instagram reddit tiktok twitter youtube
end
