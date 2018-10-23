{stdenv}:

stdenv.mkDerivation rec {
  name = "config-vim";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -D $src/vimrc $out/target-home/.vimrc
  '';
}
