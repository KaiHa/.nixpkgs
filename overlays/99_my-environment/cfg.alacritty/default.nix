{stdenv}:

stdenv.mkDerivation rec {
  name = "config-alacritty";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/alacritty.yml      $out/target-home/DOT.config/alacritty/alacritty.yml
    install -Dm 444 $src/alacritty-dark.yml $out/target-home/DOT.config/alacritty/alacritty-dark.yml
  '';
}
