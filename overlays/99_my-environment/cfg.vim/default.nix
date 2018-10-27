{stdenv}:

stdenv.mkDerivation rec {
  name = "config-vim";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/vimrc $out/target-home/DOT.vimrc
  '';
}
