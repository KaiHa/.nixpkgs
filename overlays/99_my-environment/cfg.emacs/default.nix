{stdenv, bash, coreutils, emacs, glibcLocales, graphicsmagick-imagemagick-compat, mediainfo, tzdata, weechat, writeText}:

let
  emacsService = writeText "emacs.service" ''
    ## If your Emacs is installed in a non-standard location, you may need
    ## to copy this file to a standard directory, eg ~/.config/systemd/user/ .
    ## If you install this file by hand, change the "Exec" lines below
    ## to use absolute file names for the executables.
    [Unit]
    Description=Emacs text editor
    Documentation=info:emacs man:emacs(1) https://gnu.org/software/emacs/
    
    [Service]
    Environment="LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive"
    Environment="TZDIR=${tzdata}/share/zoneinfo"
    Environment=PKG_CONFIG_PATH=$HOME/.nix-profile/lib/pkgconfig/
    Environment=C_INCLUDE_PATH=$HOME/.nix-profile/include/
    
    Type=notify
    ExecStart=${bash}/bin/bash -c 'source /etc/profile; PATH="$PATH:${graphicsmagick-imagemagick-compat}/bin:${mediainfo}/bin:${weechat}/bin" exec ${emacs}/bin/emacs --fg-daemon'
    ExecStop=${emacs}/bin/emacsclient --eval "(kill-emacs)"
    # The location of the SSH auth socket varies by distribution, and some
    # set it from PAM, so don't override by default.
    # Environment=SSH_AUTH_SOCK=%t/keyring/ssh
    Restart=on-failure
    
    [Install]
    WantedBy=default.target
  '';
in

stdenv.mkDerivation rec {
  name = "config-emacs";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -dm 755 "$out/target-home/DOT.config/emacs"
    install -dm 755 "$out/target-home/DOT.config/systemd/user/default.target.wants"
    install -Dm 444 ${emacsService}              "$out/target-home/DOT.config/systemd/user/emacs.service"
    install -Dm 444 ${emacsService}              "$out/target-home/DOT.config/systemd/user/default.target.wants/emacs.service"
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
