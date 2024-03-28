#! /usr/bin/env fish

argparse --name=archive --min-args=1 --max-args=1 's/site=' 'd/dest=' -- $argv
or return

function instagram_user --argument-names dest username
  if test -n $dest
    echo gallery-dl https://instagram.com/$username -d "$ARCHIVE_DIR/instagram/$dest"
    gallery-dl https://instagram.com/$username -d "$ARCHIVE_DIR/instagram/$dest"
  else 
    echo gallery-dl https://instagram.com/$username -d "$ARCHIVE_DIR/instagram/$username"
    gallery-dl https://instagram.com/$username -d "$ARCHIVE_DIR/instagram/$username"
  end
end

function reddit_user --argument-names dest username
  if test -n $dest
    echo gallery-dl https://reddit.com/user/$username -d "$ARCHIVE_DIR/reddit/$dest"
    gallery-dl https://reddit.com/user/$username -d "$ARCHIVE_DIR/reddit/$dest"
  else 
    echo gallery-dl https://reddit.com/user/$username -d "$ARCHIVE_DIR/reddit/$username"
    gallery-dl https://reddit.com/user/$username -d "$ARCHIVE_DIR/reddit/$username"
  end
end

function twitter_user --argument-names dest username
  if test -n $dest
    echo gallery-dl https://twitter.com/$username -d "$ARCHIVE_DIR/twitter/$dest"
    gallery-dl https://twitter.com/$username -d "$ARCHIVE_DIR/twitter/$dest"
  else 
    echo gallery-dl https://twitter.com/$username -d "$ARCHIVE_DIR/twitter/$username"
    gallery-dl https://twitter.com/$username -d "$ARCHIVE_DIR/twitter/$username"
  end
end

switch $_flag_site
  case instagram
    instagram_user "$_flag_dest" $argv
  case reddit
    reddit_user "$_flag_dest" $argv
  case twitter
    twitter_user "$_flag_dest" $argv
  case '*'
    echo Valid sites: instagram reddit twitter
end
