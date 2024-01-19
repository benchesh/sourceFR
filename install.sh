#!/bin/bash

sourceFRsrc=".shell_sourceFR/src.sh"

(
  if [[ $SHELL != *"zsh"* ]] && [[ $SHELL != *"bash"* ]]; then
    echo "ERROR: sourceFR only supports zsh & bash at this time. To switch from $SHELL to zsh, try running this command and then run the install script again:"
    echo "chsh -s /bin/zsh"
    exit 1
  fi

  mkdir -p "$HOME/$(dirname "$sourceFRsrc")/cache"

  echo "Installing sourceFR..."
  curl -fsSL -o "$HOME/$sourceFRsrc" "https://raw.githubusercontent.com/benchesh/sourceFR/main/$(basename "$sourceFRsrc")"
  curl -fsSL -o "$HOME/$(dirname "$sourceFRsrc")/LICENSE" "https://raw.githubusercontent.com/benchesh/sourceFR/main/LICENSE"

  updateRcFile() {
    if [[ -f "$1" ]]; then
      local catRC="$(echo "$(cat "$1")")"
      local filteredRC="$(echo "$catRC" | sed -e "s/.*\(###SOURCEFR\).*//g")"$'\n' # remove sourceFR if it exists already
    fi

    local newRC="$filteredRC$sourceFRload"$'\n'

    if [[ ! -f "$1" ]]; then
      printf "%s" "$newRC" >"$1"
      echo "Saved new \"$1\" file"
    elif [[ "$catRC" != "$newRC" ]]; then
      printf "%s" "$newRC" >"$1"
      echo "Updated \"$1\" file"
    fi
  }

  sourceFRload="[ -f \"\$HOME/$sourceFRsrc\" ] && source \"\$HOME/$sourceFRsrc\" ###SOURCEFR###"

  checkRCFile() {
    if [[ -f "$1" ]]; then
      local rcFinalLine="$(tail -n 1 "$1")"
    fi

    if [[ "$rcFinalLine" != "$sourceFRload" ]]; then
      updateRcFile "$1" #add sourceFRload to the end of the file (or remove sourceFRload in case it already exists and place it at the end of the file)
    fi
  }

  checkRCFile "$HOME/.zshrc"
  checkRCFile "$HOME/.bashrc"

  echo sourceFR installed!
)

source "$HOME/$sourceFRsrc"
