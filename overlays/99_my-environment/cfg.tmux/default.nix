{stdenv, urlview, open}:

stdenv.mkDerivation rec {
  name = "config-tmux";

  buildInputs = [ urlview open ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -dm 755 $out/target-home
    substitute $src/tmux.conf $out/target-home/.tmux.conf \
               --subst-var-by open    ${open}/share/tmux-plugins/open/open.tmux \
               --subst-var-by urlview ${urlview}/share/tmux-plugins/urlview/urlview.tmux
  '';
}
