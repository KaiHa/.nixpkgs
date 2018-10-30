{stdenv}:

stdenv.mkDerivation rec {
  name = "config-zsh";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/zshrc $out/target-home/DOT.zshrc
  '';
}
