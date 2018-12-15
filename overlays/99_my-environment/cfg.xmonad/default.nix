{ mkDerivation, base, stdenv, xmonad, xmonad-contrib, writeText }:

let
  buildSh = writeText "build" ''
    #!/usr/bin/env bash
    true
  '';
in
mkDerivation {
  pname = "myxmonad";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base xmonad xmonad-contrib ];
  license = stdenv.lib.licenses.bsd3;

  postPatch = ''
    substitute xmobarrc.in xmobarrc \
               --subst-var-by datapath $out/share/x86_64-linux-ghc-8.4.3/myxmonad-0.1.0.0
  '';


  postInstall = ''
    install -dm 755 "$out/target-home/DOT.xmonad"
    install -Dm 555 ${buildSh}  "$out/target-home/DOT.xmonad/build"
    ln -s "$out/bin/xmonad-x86_64-linux" "$out/target-home/DOT.xmonad/xmonad-x86_64-linux"
  '';
}
