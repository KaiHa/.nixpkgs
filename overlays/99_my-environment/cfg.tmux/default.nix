{stdenv, acpitool, notmuch, open, urlview}:

stdenv.mkDerivation rec {
  name = "config-tmux";

  buildInputs = [ acpitool notmuch open urlview ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -dm 755 $out/target-home
    substitute $src/tmux.conf $out/target-home/DOT.tmux.conf \
               --subst-var-by acpitool ${acpitool}/bin/acpitool \
               --subst-var-by notmuch  ${notmuch}/bin/notmuch \
               --subst-var-by open     ${open}/share/tmux-plugins/open/open.tmux \
               --subst-var-by urlview  ${urlview}/share/tmux-plugins/urlview/urlview.tmux
  '';
}
