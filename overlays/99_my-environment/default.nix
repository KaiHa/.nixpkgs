self: super:
rec {
  pkgs1803 = import (fetchTarball https://nixos.org/channels/nixos-18.03/nixexprs.tar.xz) {};

  diffoscope_custom = super.diffoscope.override { enableBloat = true; };
  emacs_custom      = super.emacsWithPackages (p: [ self.ghostscript ]);
  gnupg             = super.gnupg.override { pinentry = self.pinentry; };
  lbdb              = super.lbdb.override { inherit gnupg; goobook = self.python27Packages.goobook; };
  # XXX Install xmobar from 18.03 because the 18.09 version is broken for me
  xmobar_custom     = pkgs1803.haskellPackages.xmobar;
  zathura           = super.zathura.override { synctexSupport = false; };

  _cfg-alacritty = super.callPackage ./cfg.alacritty {};
  _cfg-emacs     = super.callPackage ./cfg.emacs     {};
  _cfg-git       = super.callPackage ./cfg.git       {};
  _cfg-notmuch   = super.callPackage ./cfg.notmuch   {};
  _cfg-mc        = super.callPackage ./cfg.mc        {};
  _cfg-ssh       = super.callPackage ./cfg.ssh       {};
  _cfg-tmux      = super.callPackage ./cfg.tmux      { inherit (self.tmuxPlugins) open urlview; };
  _cfg-urlview   = super.callPackage ./cfg.urlview   {};
  _cfg-vim       = super.callPackage ./cfg.vim       {};
  _cfg-zsh       = super.callPackage ./cfg.zsh       {};

  haskellPackages = super.haskellPackages.override {
    overrides = hs_self: hs_super: {
      _cfg-xmonad = hs_self.callPackage ./cfg.xmonad {};
    };
  };

  myDefaultEnv = with self; buildEnv {
    name = "myDefaultEnv";
    paths = [
      _cfg-alacritty
      _cfg-emacs
      _cfg-git
      _cfg-mc
      _cfg-tmux
      _cfg-urlview
      _cfg-vim
      _cfg-zsh
      (aspellWithDicts (p: [ p.de p.en ] ))
      aescrypt
      alacritty
      emacs_custom
      gitAndTools.git-annex
      gitRepo
      gmailieer
      hack-font
      lbdb
      mc
      mosh
      ncdu
      nix-zsh-completions
      notmuch
      shellcheck
      tmux
      urlview
      weechat
      xclip
      zathura
      zsh
    ];
  };

  myDesktopEnv = with self; buildEnv {
    name = "myDesktopEnv";
    paths = [
      haskellPackages._cfg-xmonad
      dmenu
      gmrun
      stalonetray
      unclutter-xfixes
      xmobar_custom
      xorg.xbacklight
      xorg.xev
      xorg.xmessage
      xrandr-invert-colors
    ];
  };

  myPrivateEnv = with self; buildEnv {
    name = "myPrivateEnv";
    paths = [
      _cfg-notmuch
      _cfg-ssh
    ];
  };


  myHeavyEnv = with self; buildEnv {
    name = "myHeavyEnv";
    paths = [
      #_ghc
      diffoscope_custom
    ];
  };
}
