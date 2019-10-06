(add-to-list 'load-path "~/.nix-profile/share/emacs/site-lisp/")

(setq
 package-archive-priorities '(("melpa-stable" . 9)
                              ("gnu"          . 1))
 package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
                    ("melpa"        . "https://melpa.org/packages/")
                    ("gnu"          . "https://elpa.gnu.org/packages/"))

 package-selected-packages '(bitbake
                             calfw
                             calfw-cal
                             company-ghci
                             counsel
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
                             iedit
                             ivy
                             ivy-historian
                             ivy-hydra
                             ivy-rich
                             ivy-rtags
                             json-mode
                             magit
                             magit-annex
                             ;;magit-todos
                             markdown-mode
                             modalka
                             nix-mode
                             org-gcal
                             org-pdfview
                             pdf-tools
                             rtags
                             rust-mode
                             ;;scion
                             undo-tree
                             which-key
                             yaml-mode)

 package-pinned-packages '((german-holidays . "melpa")))

;; Use the following commands to install the selected packages:
;;
;;  (package-refresh-contents)
;;  (package-install-selected-packages)
