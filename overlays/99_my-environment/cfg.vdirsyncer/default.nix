{stdenv, vdirsyncerStable}:

stdenv.mkDerivation rec {
  name = "config-vdirsyncer";

  buildInputs = [ vdirsyncerStable ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -dm 755 $out/target-home/DOT.config/vdirsyncer
    substitute $src/config $out/target-home/DOT.config/vdirsyncer/config \
               --subst-var-by vdirsyncer ${vdirsyncerStable}
  '';
}
