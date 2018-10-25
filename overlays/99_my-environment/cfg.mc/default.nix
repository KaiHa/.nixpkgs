{stdenv}:

stdenv.mkDerivation rec {
  name = "config-mc";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -D $src/ini $out/target-home/DOT.config/mc/ini
    install -D $src/mc.keymap $out/target-home/DOT.config/mc/mc.keymap
  '';
}
