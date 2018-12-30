{stdenv, aescrypt}:

stdenv.mkDerivation rec {
  name = "config-emacs-private";

  buildInputs = [ aescrypt ];

  phases = [ "installPhase" ];

  src = ./.;

  secret = import <secret>;

  installPhase = ''
    install -dm 755 "$out/target-home/DOT.config/emacs"
    aescrypt -d -p "${secret}" -o "$out/target-home/DOT.config/emacs/private.el" "$src/private.el.aes"
  '';
}
