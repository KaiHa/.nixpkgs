{ mkDerivation, base, stdenv, xmonad, xmonad-contrib }:
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
}
