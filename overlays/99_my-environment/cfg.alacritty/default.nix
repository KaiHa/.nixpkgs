{stdenv}:

stdenv.mkDerivation rec {
  name = "config-alacritty";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -D $src/alacritty.yml $out/target-home/DOT.config/alacritty/alacritty.yml
  '';
}