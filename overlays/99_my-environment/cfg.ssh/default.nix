{stdenv, aescrypt}:

stdenv.mkDerivation rec {
  name = "config-ssh";

  buildInputs = [ aescrypt ];

  phases = [ "installPhase" ];

  src = ./.;

  secret = import <secret>;

  installPhase = ''
    install -d "$out/target-home/DOT.ssh/"
    aescrypt -d -p "${secret}" -o "$out/target-home/DOT.ssh/config" "$src/config.aes"
  '';
}
