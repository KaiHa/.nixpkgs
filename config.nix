{
  allowUnfree = true;

  diffoscope = { enableBloat = true; };

  packageOverrides = super: with super; {

    _cfg-alacritty = import ./cfg.alacritty { inherit (pkgs) stdenv; };
    _cfg-mc        = import ./cfg.mc        { inherit (pkgs) stdenv; };
    _cfg-tmux      = import ./cfg.tmux      { inherit (pkgs) stdenv; inherit (tmuxPlugins) open urlview; };
    _cfg-urlview   = import ./cfg.urlview   { inherit (pkgs) stdenv; };
    _cfg-vim       = import ./cfg.vim       { inherit (pkgs) stdenv; };
    _cfg-zsh       = import ./cfg.zsh       { inherit (pkgs) stdenv; };

    myDefaultEnv = with pkgs; buildEnv {
      name = "myDefaultEnv";

      paths = [
        _cfg-alacritty
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

    myHeavyEnv = with pkgs; buildEnv {
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
  };
}
