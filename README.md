# dotconfig-nixpkgs aka dotfiles with nix

This is a fork of https://github.com/kamilchm/.nixpkgs that I have
heavily adapted to my needs.

## Fully declarative user environment

1. Use [nix](https://nixos.org/nix/) to manage all your user space
   programs
   [declaratively](https://fix.me).
2. Prepare **dotfiles** with [injected](https://fix.me)
   dependencies from https://github.com/NixOS/nixpkgs and install it
   into **$out/target-home**.
3. Link **dotfiles** from *.nix-profile* into user home directory.

## How to use it?

1. Install [nix](https://nixos.org/nix/)
2. Git clone **dotconfig-nixpkgs** into **~/.config/nixpkgs**
3. Customize it for your needs.
4. Run `.config/nixpkgs/install.sh`
