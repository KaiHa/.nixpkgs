{stdenv}:

stdenv.mkDerivation rec {
  name = "config-ini";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -D $src/ini $out/target-home/.config/mc/ini
    install -D $src/mc.keymap $out/target-home/.config/mc/mc.keymap
  '';
}
