self: super:
rec {
  diffoscope = super.diffoscope.override { enableBloat = true; };

  _cfg-alacritty = super.callPackage ./cfg.alacritty {};
  _cfg-git       = super.callPackage ./cfg.git       {};
  _cfg-mc        = super.callPackage ./cfg.mc        {};
  _cfg-tmux      = super.callPackage ./cfg.tmux      { inherit (self.tmuxPlugins) open urlview; };
  _cfg-urlview   = super.callPackage ./cfg.urlview   {};
  _cfg-vim       = super.callPackage ./cfg.vim       {};
  _cfg-zsh       = super.callPackage ./cfg.zsh       {};

  myDefaultEnv = with self; buildEnv {
    name = "myDefaultEnv";

    paths = [
      _cfg-alacritty
      _cfg-git
      _cfg-mc
      _cfg-tmux
      _cfg-urlview
      _cfg-vim
      _cfg-zsh
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

  myHeavyEnv = with self; buildEnv {
    name = "myHeavyEnv";

    paths = [
      myDefaultEnv
      diffoscope
      #_emacs
      #_ghc
      aspell
      aspellDicts.de
      aspellDicts.en
    ];
  };
}