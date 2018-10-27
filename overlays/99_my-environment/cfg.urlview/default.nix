{stdenv}:

stdenv.mkDerivation rec {
  name = "config-urlview";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/urlview $out/target-home/DOT.urlview
  '';
}
