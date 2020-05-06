{stdenv, zile}:

stdenv.mkDerivation rec {
  name = "config-zsh";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -dm 755 $out/target-home
    substitute $src/zshrc $out/target-home/DOT.zshrc \
               --subst-var-by zile ${zile}/bin/zile
  '';
}
