self: super:
rec {
  diffoscope = super.diffoscope.override { enableBloat = false; };

  emacs = super.emacsWithPackages (p:
    [ self.ghostscript
      self.pinentry-emacs
      self.poppler_utils
      p.org-pdftools
      p.pdf-tools
    ]);

  mytexlive = super.texlive.combine {
    inherit (super.texlive) capt-of enumitem lastpage scheme-medium fontawesome moderncv sectsty wrapfig xcolor-solarized;
  };

  weechat = super.weechat.override {
    configure = { availablePlugins, ... }: {
      scripts = with self.weechatScripts; [ weechat-matrix ];
      plugins = with availablePlugins; [
        guile
        lua
        (python.withPackages (ps: with ps; [ future
                                             Logbook
                                             matrix-nio
                                             pyopenssl
                                             webcolors
                                           ]))
      ];
    };
  };

  _cfg-alacritty     = super.callPackage ./cfg.alacritty     {};
  _cfg-desktop       = super.callPackage ./cfg.desktop       {};
  _cfg-emacs         = super.callPackage ./cfg.emacs         {};
  _cfg-emacs-private = super.callPackage ./cfg.emacs-private {};
  _cfg-git           = super.callPackage ./cfg.git           {};
  _cfg-notmuch       = super.callPackage ./cfg.notmuch       {};
  _cfg-mc            = super.callPackage ./cfg.mc            {};
  _cfg-redshift      = super.callPackage ./cfg.redshift      {};
  _cfg-ssh           = super.callPackage ./cfg.ssh           {};
  _cfg-tmux          = super.callPackage ./cfg.tmux          { inherit (self.tmuxPlugins) open urlview; };
  _cfg-urlview       = super.callPackage ./cfg.urlview       {};
  _cfg-vdirsyncer    = super.callPackage ./cfg.vdirsyncer    {};
  _cfg-vim           = super.callPackage ./cfg.vim           {};
  _cfg-zsh           = super.callPackage ./cfg.zsh           {};
  _sway-win-select   = super.callPackage ~/sw/my/sway-window-select { inherit (self.haskellPackages) mkDerivation aeson base bytestring containers extra fmt optparse-applicative pretty-simple split stdenv typed-process; };

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
      hack-font
      hicolor-icon-theme
      mc
      mosh
      ncdu
      nix-zsh-completions
      notmuch
      offlineimap
      pass
      shellcheck
      tmux
      tmux.man
      urlview
      weechat
      xdg_utils
      zathura
      zile
      zsh
      zsh-completions
    ];
  };

  myDesktopEnv = with self; buildEnv {
    name = "myDesktopEnv";
    paths = [
      _cfg-desktop
#      _cfg-redshift
      _sway-win-select
      bemenu
      dmenu
      i3status
      wl-clipboard
    ];
  };

  myHaskellEnv = with self; buildEnv {
    name = "myHaskellEnv";
    paths = [
      (haskellPackages.ghcWithPackages (p: with p; [
        alex
        cabal-install
        doctest
        happy
        haskell-language-server
        hlint
        # hoogle
        # pointfree
      ]))
      cabal2nix
      fontconfig.dev
      freetype.dev
      ghcid
      ormolu
      pkgconfig
    ];
  };

  myPrivateEnv = with self; buildEnv {
    name = "myPrivateEnv";
    paths = [
      _cfg-emacs-private
      _cfg-notmuch
      _cfg-vdirsyncer
      _cfg-ssh
      vdirsyncerStable
    ];
  };


  myHeavyEnv = with self; buildEnv {
    name = "myHeavyEnv";
    paths = [
      calibre
      diffoscope
      gdb
      inkscape
      khal
      libreoffice
      manpages
      pianobooster
      signal-cli
      signal-desktop
      squashfsTools
    ];
  };
}
