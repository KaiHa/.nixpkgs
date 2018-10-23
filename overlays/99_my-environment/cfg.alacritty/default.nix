{stdenv}:

stdenv.mkDerivation rec {
  name = "config-alacritty";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -D $src/alacritty.yml $out/target-home/.config/alacritty/alacritty.yml
  '';
}
