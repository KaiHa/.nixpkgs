{stdenv, aescrypt, bash, coreutils, glibcLocales, gmailieer, notmuch, tzdata, writeText}:

let
  fmService = writeText "fetch-mail.service" ''
    [Unit]
    Description=Fetch mail

    [Service]
    Environment="LOCALE_ARCHIVE=${glibcLocales}/lib/locale/locale-archive"
    Environment="PATH=${bash}/bin:${gmailieer}/bin:${notmuch}/bin:${coreutils}/bin"
    Environment="TZDIR=${tzdata}/share/zoneinfo"

    ExecStart=${notmuch}/bin/notmuch new
    Type=oneshot

    [Install]
    WantedBy=fetch-mail.timer
  '';

  fmTimer = writeText "fetch-mail.timer" ''
    [Unit]

    [Timer]
    OnCalendar=*-*-* *:0/5:00
    Unit=fetch-mail.service

    [Install]
    WantedBy=default.target
  '';
in

stdenv.mkDerivation rec {
  name = "config-notmuch";

  buildInputs = [ aescrypt ];

  phases = [ "installPhase" ];

  src = ./.;

  secret = import <secret>;

  installPhase = ''
    install -dm 755 "$out/target-home/DOT.config/systemd/user/default.target.wants"
    install -dm 755 "$out/target-home/DOT.config/systemd/user/fetch-mail.timer.wants"
    install -Dm 444 ${fmService}        "$out/target-home/DOT.config/systemd/user/fetch-mail.service"
    install -Dm 444 ${fmService}        "$out/target-home/DOT.config/systemd/user/fetch-mail.timer.wants/fetch-mail.service"
    install -Dm 444 ${fmTimer}          "$out/target-home/DOT.config/systemd/user/fetch-mail.timer"
    install -Dm 444 ${fmTimer}          "$out/target-home/DOT.config/systemd/user/default.target.wants/fetch-mail.timer"
    install -Dm 444 $src/notmuch-config "$out/target-home/DOT.notmuch-config"
    install -Dm 755 $src/pre-new        "$out/target-home/DOT.mail/DOT.notmuch/hooks/pre-new"
    aescrypt -d -p "${secret}" -o "$out/target-home/DOT.mail/DOT.notmuch/hooks/post-new" "$src/post-new.aes"
    chmod 755 $out/target-home/DOT.mail/DOT.notmuch/hooks/post-new
  '';
}
