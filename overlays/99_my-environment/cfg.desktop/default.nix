{stdenv}:

stdenv.mkDerivation rec {
  name = "config-desktop";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/i3status.config            $out/target-home/DOT.config/i3status/config
    install -Dm 444 $src/keep-calm.png              $out/target-home/DOT.config/sway/keep-calm.png
    install -Dm 444 $src/sway.config                $out/target-home/DOT.config/sway/config
    install -Dm 755 $src/run-or-raise.sh            $out/target-home/bin/run-or-raise.sh
    install -Dm 755 $src/status.sh                  $out/target-home/bin/status.sh
    install -Dm 755 $src/signal-desktop.sh          $out/target-home/bin/signal-desktop.sh
    install -Dm 755 $src/skype.sh                   $out/target-home/bin/skype.sh
    install -Dm 755 $src/toggle-light-dark-theme.sh $out/target-home/bin/toggle-light-dark-theme.sh
    install -Dm 755 $src/toggle-monitor-setup.sh    $out/target-home/bin/toggle-monitor-setup.sh
  '';
}
