self: super:
rec {
  diffoscope_custom = super.diffoscope.override { enableBloat = true; };
  emacs_custom = super.emacsWithPackages (p: [ self.ghostscript p.org ]);

  _cfg-alacritty = super.callPackage ./cfg.alacritty {};
  _cfg-emacs     = super.callPackage ./cfg.emacs     { inherit (self.emacsPackages) org; };
  _cfg-git       = super.callPackage ./cfg.git       {};
  _cfg-notmuch   = super.callPackage ./cfg.notmuch   {};
  _cfg-mc        = super.callPackage ./cfg.mc        {};
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
      aescrypt
      alacritty
      gitAndTools.git-annex
      gitRepo
      hack-font
      mc
      mosh
      notmuch
      shellcheck
      tmux
      urlview
      zsh
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
      diffoscope_custom
      #_emacs
      #_ghc
      aspell
      aspellDicts.de
      aspellDicts.en
    ];
  };
}
