{stdenv}:

stdenv.mkDerivation rec {
  name = "config-alacritty";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/alacritty-light.yml $out/target-home/DOT.config/alacritty/alacritty-light.yml
    install -Dm 444 $src/alacritty-dark.yml  $out/target-home/DOT.config/alacritty/alacritty-dark.yml
  '';
}
