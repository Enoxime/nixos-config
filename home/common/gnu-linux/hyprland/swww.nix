{ pkgs, ... }: {
  home.file = {
    swww_randomize = {
      enable = true;
      executable = true;
      target = "./.config/swww/swww_randomize.sh";
      text = ''
        #!/usr/bin/env sh
        # Changes the wallpaper to a randomly chosen image in a given directory
        # at a set interval.

        DEFAULT_INTERVAL=60 # In seconds

        if [ $# -lt 1 ] || [ ! -d "$1" ]; then
          printf "Usage:\n\t\e[1m%s\e[0m \e[4mDIRECTORY\e[0m [\e[4mINTERVAL\e[0m]\n" "$0"
          printf "\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds (or every %d seconds if unspecified)." "$DEFAULT_INTERVAL"
          exit 1
        fi

        # See swww-img(1)
        RESIZE_TYPE="crop"
        export SWWW_TRANSITION_FPS="''${SWWW_TRANSITION_FPS:-60}"
        export SWWW_TRANSITION_STEP="''${SWWW_TRANSITION_STEP:-2}"

        while true; do
          find -L "$1" -type f \
          | while read -r img; do
            echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
          done \
          | sort -n | cut -d':' -f2- \
          | while read -r img; do
            swww img --transition-type any --resize="$RESIZE_TYPE" "$img"
            sleep "''${2:-$DEFAULT_INTERVAL}"
          done
        done
      '';
    };

    swww_daynnight = {
      enable = true;
      executable = true;
      target = "./.config/swww/swww_daynnight.sh";
      text = ''
        #!/usr/bin/env bash
        # Change the wallpaper to a randomly chosen image in a given directories
        # at a set interval depending of the time of the day.

        DEFAULT_INTERVAL=60 # In seconds

        if [ $# -lt 1 ] || [ ! -d "$1" ] || [ $# -lt 2 ] || [ ! -d "$2" ]; then
          printf "Usage:\n\t\e[1m%s\e[0m \e[4mDAY_DIRECTORY\e[0m \e[4mNIGHT_DIRECTORY\e[0m [\e[4mINTERVAL\e[0m]\n" "$0"
          printf "\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds (or every %d seconds if unspecified)." "$DEFAULT_INTERVAL"
          exit 1
        fi

        # See swww-img(1)
        RESIZE_TYPE="crop"
        export SWWW_TRANSITION_FPS="''${SWWW_TRANSITION_FPS:-60}"
        export SWWW_TRANSITION_STEP="''${SWWW_TRANSITION_STEP:-2}"

        while true; do
          __current_time=$(date +%H:%M)
          if [[ "''${__current_time}" > "18:00" ]] || [[ "''${__current_time}" < "08:00" ]]; then
            __img_dir="$2"
          else
            __img_dir="$1"
          fi

          find -L "$__img_dir" -type f \
          | while read -r img; do
            echo "$(</dev/urandom tr -dc a-zA-Z0-9 | head -c 8):$img"
          done \
          | sort -n | cut -d':' -f2- \
          | while read -r img; do
            swww img --transition-type any --resize="$RESIZE_TYPE" "$img"
            sleep "''${3:-$DEFAULT_INTERVAL}"
          done
        done
      '';
    };

    # https://github.com/JaKooLit/Wallpaper-Bank/tree/main
    wallpapers = {
      enable = true;
      recursive = true;
      source = pkgs.fetchgit {
        url = "https://github.com/JaKooLit/Wallpaper-Bank";
        rev = "4f3ada0efcd1e485bb9ebab8fb3612547bba1d5e";
        sha256 = "sha256-lrWGTDk5OfkMXttiCQKFnY7Sz5nUkz1G6gQCOjM0WI0=";
      };
      target = "./.config/swww/wallpapers";
    };
  };
}
