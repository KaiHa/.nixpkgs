{stdenv}:

stdenv.mkDerivation rec {
  name = "config-alacritty";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/alacritty.yml $out/target-home/DOT.config/alacritty/alacritty.yml
  '';
}
