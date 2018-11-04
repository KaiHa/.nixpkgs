{stdenv, aescrypt}:

stdenv.mkDerivation rec {
  name = "config-notmuch";

  buildInputs = [ aescrypt ];

  phases = [ "installPhase" ];

  src = ./.;

  secret = import <secret>;

  installPhase = ''
    install -Dm 444 $src/notmuch-config "$out/target-home/DOT.notmuch-config"
    install -Dm 755 $src/pre-new        "$out/target-home/DOT.mail/DOT.notmuch/hooks/pre-new"
    aescrypt -d -p "${secret}" -o "$out/target-home/DOT.mail/DOT.notmuch/hooks/post-new" "$src/post-new.aes"
    chmod 755 $out/target-home/DOT.mail/DOT.notmuch/hooks/post-new
  '';
}
