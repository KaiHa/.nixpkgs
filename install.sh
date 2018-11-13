#!/usr/bin/env bash
set -e

lnk ()
{
  src=${1:?}
  dest=${2:?}

  if [[ $(readlink -f "$src") = $(readlink -f "$dest") ]]; then
      echo "info: link $dest already OK"
  elif [[ -e "$dest" ]]; then
      echo "error: '$dest' already exists but links NOT to '$src', will NOT overwrite" >&2
      exit 1
  else
      echo "info: creating link $src -> $dest"
      mkdir -p "$(dirname "$dest")"
      ln -s "$src" "$dest"
  fi
}


selfdir=$(dirname $(readlink -f $0))
env=${1:-myDefaultEnv}
if [[ $# -ge 1 ]]; then shift; fi

echo "Installing nix profile: $env $@"
if [[ "$env" == "myPrivateEnv" ]]; then
  gpg --decrypt --output $selfdir/secret $selfdir/secret.gpg
  trap "rm $selfdir/secret" EXIT
  NIX_PATH=$NIX_PATH${NIX_PATH:+:}secret=$selfdir/secret
fi

nix-env -i $env "$@"

echo "Creating dotfiles links in $HOME"
( cd "$HOME"
  while read -r src; do
      target=${src#.nix-profile/target-home/}
      # hidden files are ignored by nix when linking into the profile,
      # therefore we are replacing 'DOT.' here by '.'
      target=${target//DOT\./.}
      lnk "$HOME/$src" "$target"
  done < <(find -L .nix-profile/target-home/ -type f)
)

lnk ~/.nix-profile/share/fonts/ ~/.fonts
