;; -*-emacs-lisp-*-
;;
;; Example Emacs configuration. Place this file at ~/.config/emacs/init.el.
;;

;;;; My default settings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-file "~/.config/emacs/packages.el")

(require 'package)

(load-file "~/.config/emacs/calendar.el")
;;(load-file "~/.config/emacs/email.el")
(load-file "~/.config/emacs/functions.el")
(load-file "~/.config/emacs/haskell.el")
(load-file "~/.config/emacs/keybindings_and_hooks.el")
(load-file "~/.config/emacs/misc.el")
(load-file "~/.config/emacs/modes.el")
(load-file "~/.config/emacs/nix-list-generations.el")
(load-file "~/.config/emacs/nix-shell.el")
(load-file "~/.config/emacs/org.el")
;;(load-file "~/.config/emacs/private.el")

;;;; Deviations from the defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Customization ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
