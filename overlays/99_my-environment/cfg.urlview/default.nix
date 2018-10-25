{stdenv}:

stdenv.mkDerivation rec {
  name = "config-urlview";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -D $src/urlview $out/target-home/DOT.urlview
  '';
}
