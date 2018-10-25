{stdenv}:

stdenv.mkDerivation rec {
  name = "config-zsh";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -D $src/zshrc $out/target-home/DOT.config/zsh/zshrc
  '';
}
