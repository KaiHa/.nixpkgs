{stdenv}:

stdenv.mkDerivation rec {
  name = "config-mc";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/ini $out/target-home/DOT.config/mc/ini
    install -Dm 444 $src/mc.keymap $out/target-home/DOT.config/mc/mc.keymap
  '';
}
