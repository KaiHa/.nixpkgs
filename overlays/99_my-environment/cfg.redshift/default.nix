{stdenv, bash, coreutils, glibcLocales, redshift, tzdata, writeText}:

let
  redshiftService = writeText "redshift.service" ''
    [Unit]
    Description=Emacs: redshift - set color temperature of display according to time of day

    [Service]
    Environment="LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive"
    Environment="PATH=${bash}/bin:${coreutils}/bin"
    Environment="TZDIR=${tzdata}/share/zoneinfo"

    ExecStart=${redshift}/bin/redshift
    Restart=always

    [Install]
    WantedBy=default.target
  '';
in

stdenv.mkDerivation rec {
  name = "config-redshift";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -Dm 444 $src/redshift.conf $out/target-home/DOT.config/redshift.conf
    install -Dm 444 ${redshiftService} "$out/target-home/DOT.config/systemd/user/redshift.service"
    install -Dm 444 ${redshiftService} "$out/target-home/DOT.config/systemd/user/default.target.wants/redshift.service"
  '';
}
