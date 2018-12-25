self: super:
rec {
  diffoscope = super.diffoscope.override { enableBloat = true; };
  emacs26    = super.emacs26.override { imagemagick = self.imagemagick; };
  emacs      = super.emacsWithPackages (p: [ self.ghostscript ]);
  gnupg      = super.gnupg.override { pinentry = self.pinentry; };
  lbdb       = super.lbdb.override { inherit gnupg; goobook = self.python27Packages.goobook; };
  zathura    = super.zathura.override { synctexSupport = false; };

  haskellPackages = super.haskellPackages.override {
    overrides = hs_self: hs_super: {
      _cfg-xmonad = hs_self.callPackage ./cfg.xmonad {};
    };
  };

  _cfg-alacritty = super.callPackage ./cfg.alacritty {};
  _cfg-emacs     = super.callPackage ./cfg.emacs     {};
  _cfg-git       = super.callPackage ./cfg.git       {};
  _cfg-notmuch   = super.callPackage ./cfg.notmuch   {};
  _cfg-mc        = super.callPackage ./cfg.mc        {};
  _cfg-rclone    = super.callPackage ./cfg.rclone    {};
  _cfg-redshift  = super.callPackage ./cfg.redshift  {};
  _cfg-ssh       = super.callPackage ./cfg.ssh       {};
  _cfg-tmux      = super.callPackage ./cfg.tmux      { inherit (self.tmuxPlugins) open urlview; };
  _cfg-urlview   = super.callPackage ./cfg.urlview   {};
  _cfg-vim       = super.callPackage ./cfg.vim       {};
  _cfg-zsh       = super.callPackage ./cfg.zsh       {};

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
      dejavu_fonts
      emacs
      gitAndTools.git-annex
      gitRepo
      gmailieer
      hack-font
      lbdb
      mc
      mosh
      ncdu
      nitrokey-app
      nix-zsh-completions
      notmuch
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      pass
      shellcheck
      symbola
      tmux
      tmux.man
      urlview
      weechat
      xclip
      zathura
      zsh
      zsh-completions
    ];
  };

  myDesktopEnv = with self; buildEnv {
    name = "myDesktopEnv";
    paths = [
      _cfg-redshift
      haskellPackages._cfg-xmonad
      haskellPackages.xmobar
      dmenu
      gmrun
      stalonetray
      unclutter-xfixes
      xorg.xbacklight
      xorg.xev
      xorg.xmessage
      xrandr-invert-colors
    ];
  };

  myHaskellEnv = with self; buildEnv {
    name = "myHaskellEnv";
    paths = [
      (haskellPackages.ghcWithPackages (p: with p; [
        alex
        bhoogle
        cabal-install
        doctest
        happy
        hlint
        hoogle
        X11
      ]))
      cabal2nix
      fontconfig.dev
      freetype.dev
      pkgconfig
      xorg.libX11.dev
      xorg.libXft.dev
      xorg.xproto
    ];
  };

  myPrivateEnv = with self; buildEnv {
    name = "myPrivateEnv";
    paths = [
      _cfg-notmuch
      _cfg-rclone
      _cfg-ssh
      rclone
    ];
  };


  myHeavyEnv = with self; buildEnv {
    name = "myHeavyEnv";
    paths = [
      diffoscope
    ];
  };
}
