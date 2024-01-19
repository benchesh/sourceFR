#!/bin/bash

# Source from repo: execute a script from a git repo in the current shell
sourceFR() {
  if [[ "$1" == "" ]] || [[ "$2" == "" ]]; then
    echo "[sourceFR] CRITICAL: Missing arguments. The first argument must be a git repo and the second argument must be a path to one script within the default branch in that repo"
  else
    local repoURL="$1"

    if [[ $(echo "$(git ls-remote "$repoURL")") == "" ]]; then
      echo "[sourceFR] CRITICAL: Could not connect to repo \"$repoURL\". Make sure you have access to the repo in this shell!"
    else
      # generate a unique ID for the repo
      local repoDirname="$(basename -- "$repoURL")"
      repoDirname="${repoDirname%\.*}_$(printf '%s' "$repoURL" | base64)"

      # the location to save a copy of the repo
      local cacheDirname="$HOME/.shell_sourceFR/cache"

      # run in a subshell so we don't need to switch the directory back
      (
        mkdir -p "$cacheDirname"
        cd "$cacheDirname"

        #get the latest copy of the repository
        if [[ -d "$repoDirname" ]]; then
          echo "[sourceFR] Pulling repo \"$repoURL\"..."
          cd "$repoDirname"
          git pull
        else
          echo "[sourceFR] Cloning repo \"$repoURL\"..."
          git clone "$repoURL" "$repoDirname"
        fi
      )

      local filePath="${@:2}"
      local fullFilePath="$cacheDirname/$repoDirname/$filePath"

      # load the script from the repository!
      if [[ -f "$fullFilePath" ]]; then
        source "$fullFilePath"
        echo "[sourceFR] Executed file \"$filePath\" from repo \"$repoURL\""
      else
        echo "[sourceFR] CRITICAL: file \"$filePath\" was not found within the default branch in repo \"$repoURL\""
      fi
    fi
  fi
}
