# dotconfig-nixpkgs aka dotfiles with nix

This is a fork of https://github.com/kamilchm/.nixpkgs that I have
heavily adapted to my needs.

## Fully declarative user environment

1. Use [nix](https://nixos.org/nix/) to manage all your user space
   programs
   [declaratively](https://fix.me).
2. Prepare **dotfiles** with [injected](https://github.com/KaiHa/dotconfig-nixpkgs/blob/58cd4b4ce93645f494bfd24b3b27e9c97a8b2b7d/overlays/99_my-environment/cfg.tmux/default.nix#L15)
   dependencies from https://github.com/NixOS/nixpkgs and install it
   into **$out/target-home**.
3. Link **dotfiles** from *.nix-profile* into user home directory.

## How to use it?

1. Install [nix](https://nixos.org/nix/)
2. Git clone **dotconfig-nixpkgs** into **~/.config/nixpkgs**
3. Customize it for your needs.
4. Run `.config/nixpkgs/install.sh`
