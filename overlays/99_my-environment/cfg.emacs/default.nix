{stdenv, org}:

stdenv.mkDerivation rec {
  name = "config-emacs";

  buildInputs = [ org ];

  phases = [ "installPhase" ];

  src = ./.;

  installPhase = ''
    install -dm 755 $out/target-home/DOT.config/emacs

    install -Dm 444 $src/calendar.el              $out/target-home/DOT.config/emacs/calendar.el
    install -Dm 444 $src/emacs.el.ex              $out/target-home/DOT.config/emacs/emacs.el.ex
    install -Dm 444 $src/evil.el                  $out/target-home/DOT.config/emacs/evil.el
    install -Dm 444 $src/ivy_et_al.el             $out/target-home/DOT.config/emacs/ivy_et_al.el
    install -Dm 444 $src/keybindings_and_hooks.el $out/target-home/DOT.config/emacs/keybindings_and_hooks.el
    install -Dm 444 $src/misc.el                  $out/target-home/DOT.config/emacs/misc.el

    substitute $src/email.el                 $out/target-home/DOT.config/emacs/email.el \
               --subst-var-by org_notmuch ${org}/share/org/contrib/lisp/org-notmuch.el
  '';
}
