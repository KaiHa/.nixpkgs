#!/usr/bin/env bash
set -e

echo "Installing nix profile"
nix-env -i myDefaultEnv

echo "Creating dotfiles links in $HOME"
( cd "$HOME"
  while read -r src; do
      target=${src#.nix-profile/target-home/}
      # hidden files are ignored by nix when linking into the profile,
      # therefore we are replacing 'DOT.' here by '.'
      target=${target//DOT\./.}
      if [[ $(readlink -f "$src") = $(readlink -f "$target") ]]; then
          echo "info: link $target already OK"
      elif [[ -e "$target" ]]; then
          echo "error: '$target' already exists but links NOT to '$src', will NOT overwrite" >&2
          exit 1
      else
          echo "info: creating link $src -> $target"
          mkdir -p "$(dirname "$target")"
          ln -s "$HOME/$src" "$target"
      fi
  done < <(find -L .nix-profile/target-home/ -type f)
)
