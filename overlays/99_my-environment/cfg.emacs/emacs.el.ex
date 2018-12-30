;; -*-Lisp-*-
;;
;; Example emacs configuration. Copy this file to ~/.emacs
;;

(require 'package)
(package-initialize)

;;;; My default settings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-file "~/.config/emacs/packages.el")
(load-file "~/.config/emacs/calendar.el")
(load-file "~/.config/emacs/email.el")
(load-file "~/.config/emacs/elfeed.el")
(load-file "~/.config/emacs/evil.el")
(load-file "~/.config/emacs/functions.el")
(load-file "~/.config/emacs/haskell.el")
(load-file "~/.config/emacs/ivy_et_al.el")
(load-file "~/.config/emacs/keybindings_and_hooks.el")
(load-file "~/.config/emacs/misc.el")
(load-file "~/.config/emacs/nix-list-generations.el")
(load-file "~/.config/emacs/org.el")
;;(load-file "~/.config/emacs/private.el")
(load-file "~/.config/emacs/rclone.el")

;;;; Deviations from the defaults ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
