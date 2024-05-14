set -l site_options instagram reddit tiktok twitter youtube

function __fish_complete_directories_in_directory -d "Complete directories found in different directory" --argument-names dir rest
  set -l saved_pwd $PWD
  builtin cd $dir

  __fish_complete_directories $rest
  
  builtin cd $saved_pwd
end

# initial options
set -l options -s -d
complete -c archive --exclusive \
  -d "Select a site to archive" \
  -n "not __fish_seen_subcommand_from $options" \
  -a "-s"
complete -c archive --exclusive \
  -d "Select a download destination within that site's directory" \
  -n "not __fish_seen_subcommand_from $options" \
  -a "-d"

# --site
complete -c archive --exclusive \
  -d "Site" \
  --short-option s --long-option site \
  -ra "$site_options" 

for site in $site_options
  # --dest
  complete -c archive --exclusive \
    -d "Username directory" \
    --short-option d --long-option dest \
    -n "__fish_seen_subcommand_from $site" \
    -a "(__fish_complete_directories_in_directory $ARCHIVE_DIR/irl/$site)" 
  
  # single positional
  complete -c archive --exclusive \
    -d "Username" \
    -n "__fish_seen_subcommand_from $site" \
    -a "(__fish_complete_directories_in_directory $ARCHIVE_DIR/irl/$site)"
end