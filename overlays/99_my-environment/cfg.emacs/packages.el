(add-to-list 'load-path "~/.nix-profile/share/emacs/site-lisp/")

(setq
 package-archive-priorities '(("melpa-stable" . 9)
                              ("gnu"          . 1))
 package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
                    ("melpa"        . "https://melpa.org/packages/")
                    ("gnu"          . "https://elpa.gnu.org/packages/"))

 package-selected-packages '(bbdb
                             bbdb-vcard
                             bitbake
                             calfw
                             calfw-cal
                             calfw-ical
                             calfw-org
                             company-ghci
                             counsel
                             csv-mode
                             dante
                             dictionary
                             dired-du
                             editorconfig
                             elfeed
                             elfeed-web
                             emms
                             emms-info-mediainfo
                             flycheck-haskell
                             flycheck-rust
                             forecast
                             german-holidays
                             haskell-mode
                             hl-todo
                             htmlize
                             iedit
                             ivy
                             ivy-historian
                             ivy-hydra
                             ivy-rich
                             ivy-rtags
                             json-mode
                             lsp-mode ;; used by rustic
                             magit
                             magit-annex
                             ;;magit-todos
                             markdown-mode
                             modalka
                             nix-mode
                             noccur
                             org-caldav
                             org-pdfview
                             pdf-tools
                             rfc-mode
                             rtags
                             rustic
                             ;;scion
                             undo-tree
                             which-key
                             yaml-mode
                             yasnippet) ;; used by rustic

 package-pinned-packages '((bbdb-vcard      . "melpa")
                           (german-holidays . "melpa")))

;; Use the following commands to install the selected packages:
;;
;;  (package-refresh-contents)
;;  (package-install-selected-packages)
