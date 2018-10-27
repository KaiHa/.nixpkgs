{stdenv}:

stdenv.mkDerivation rec {
  name = "config-git";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/config    $out/target-home/DOT.config/git/config
    install -Dm 444 $src/gitignore $out/target-home/DOT.config/git/gitignore
  '';
}
