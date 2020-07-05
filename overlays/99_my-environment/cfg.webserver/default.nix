{stdenv, nix, writeText, bash, cabal-install, coreutils, wsgidav}:

let
  webserverService = writeText "webserver.service" ''
    [Unit]
    Description=My simple webserver

    [Service]
    Environment="PATH=${bash}/bin:${coreutils}/bin:${cabal-install}/bin"
    WorkingDirectory=/home/kai/webserver/
    # TODO try to get rid of the nix-shell
    ExecStart=${nix}/bin/nix-shell --run "cabal new-run myhttp-server" shell.nix
    Restart=on-failure

    # CapabilityBoundingSet=CAP_NET_BIND_SERVICE
    # DynamicUser=true
    # InaccessiblePaths=/run
    MemoryDenyWriteExecute=true
    NoNewPrivileges=true
    PrivateTmp=true
    ProtectControlGroups=true
    # ProtectHome=true
    ProtectKernelTunables=true
    ProtectSystem=strict
    RestrictRealtime=true
    RestrictSUIDSGID=true
    SystemCallFilter=@system-service
    SystemCallFilter=~@privileged

    [Install]
    WantedBy=default.target
  '';

  wsgidavService = writeText "wsgidav.service" ''
    [Unit]
    Description=WebDAV Server

    [Service]
    Environment="PATH=${bash}/bin:${coreutils}/bin
    ExecStart=${wsgidav}/bin/wsgidav --config /home/kai/.config/nixpkgs/overlays/99_my-environment/cfg.webserver/wsgidav.conf
    Restart=on-failure

    # CapabilityBoundingSet=CAP_NET_BIND_SERVICE
    # DynamicUser=true
    # InaccessiblePaths=/run
    MemoryDenyWriteExecute=true
    NoNewPrivileges=true
    PrivateTmp=true
    ProtectControlGroups=true
    # ProtectHome=true
    ProtectKernelTunables=true
    # ProtectSystem=strict
    RestrictRealtime=true
    RestrictSUIDSGID=true
    SystemCallFilter=@system-service
    SystemCallFilter=~@privileged

    [Install]
    WantedBy=default.target
  '';

in

stdenv.mkDerivation rec {
  name = "config-webserver";

  buildInputs = [ ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -dm 755 "$out/target-home/DOT.config/systemd/user/default.target.wants"
    install -Dm 444 ${webserverService}  "$out/target-home/DOT.config/systemd/user/webserver.service"
    install -Dm 444 ${webserverService}  "$out/target-home/DOT.config/systemd/user/default.target.wants/webserver.service"
    install -Dm 444 ${wsgidavService}    "$out/target-home/DOT.config/systemd/user/wsgidav.service"
    install -Dm 444 ${wsgidavService}    "$out/target-home/DOT.config/systemd/user/default.target.wants/wsgidav.service"
  '';
}
