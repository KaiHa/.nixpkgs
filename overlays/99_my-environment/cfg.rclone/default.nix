{stdenv, aescrypt}:

stdenv.mkDerivation rec {
  name = "config-rclone";

  buildInputs = [ aescrypt ];

  phases = [ "installPhase" ];

  src = ./.;

  secret = import <secret>;

  installPhase = ''
    install -dm 755 $out/target-home/DOT.config/rclone/
    aescrypt -d -p "${secret}" -o "$out/target-home/DOT.config/rclone/rclone.conf.ex" "$src/rclone.conf.aes"
  '';
}
