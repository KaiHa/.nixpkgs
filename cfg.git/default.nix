{stdenv}:

stdenv.mkDerivation rec {
  name = "config-git";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -D $src/config    $out/target-home/.config/git/config
    install -D $src/gitignore $out/target-home/.config/git/gitignore
  '';
}
