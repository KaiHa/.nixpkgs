{stdenv, nix, writeText, _webserver}:

let
  webserverService = writeText "webserver.service" ''
    [Unit]
    Description=My simple webserver

    [Service]
    ExecStart=${_webserver}/bin/myhttp-server
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
  '';
}
