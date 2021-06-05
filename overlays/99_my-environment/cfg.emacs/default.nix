{stdenv, bash, coreutils, emacs, glibcLocales, graphicsmagick-imagemagick-compat, mediainfo, rtags, tzdata, weechat, writeText}:

stdenv.mkDerivation rec {
  name = "config-emacs";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -dm 755 "$out/target-home/DOT.config/emacs"
    install -dm 755 "$out/target-home/DOT.config/systemd/user/default.target.wants"
    install -Dm 444 $src/calendar.el              $out/target-home/DOT.config/emacs/calendar.el
    install -Dm 444 $src/init.el.ex               $out/target-home/DOT.config/emacs/init.el.ex
    install -Dm 444 $src/functions.el             $out/target-home/DOT.config/emacs/functions.el
    install -Dm 444 $src/haskell.el               $out/target-home/DOT.config/emacs/haskell.el
    install -Dm 444 $src/keybindings_and_hooks.el $out/target-home/DOT.config/emacs/keybindings_and_hooks.el
    install -Dm 444 $src/misc.el                  $out/target-home/DOT.config/emacs/misc.el
    install -Dm 444 $src/modes.el                 $out/target-home/DOT.config/emacs/modes.el
    install -Dm 444 $src/nix-list-generations.el  $out/target-home/DOT.config/emacs/nix-list-generations.el
    install -Dm 444 $src/nix-shell.el             $out/target-home/DOT.config/emacs/nix-shell.el
    install -Dm 444 $src/org.el                   $out/target-home/DOT.config/emacs/org.el
    install -Dm 444 $src/packages.el              $out/target-home/DOT.config/emacs/packages.el
  '';
}
