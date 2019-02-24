(add-to-list 'load-path "~/.nix-profile/share/emacs/site-lisp/")

(setq
 package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
                    ("melpa"        . "https://melpa.org/packages/")
                    ("gnu"          . "https://elpa.gnu.org/packages/"))

 package-selected-packages '(bitbake
                             calfw
                             calfw-cal
                             company-ghci
                             counsel
                             dante
                             dired-du
                             editorconfig
                             elfeed
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
                             org-pdfview
                             pdf-tools
                             rtags
                             rust-mode
                             ;;scion
                             undo-tree
                             which-key
                             yaml-mode)
 package-pinned-packages '((calfw         . "melpa-stable")
                           (calfw-cal     . "melpa-stable")
                           (counsel       . "melpa-stable")
                           (editorconfig  . "melpa-stable")
                           (elfeed        . "melpa-stable")
                           (haskell-mode  . "melpa-stable")
                           (hl-todo       . "melpa-stable")
                           (iedit         . "melpa-stable")
                           (ivy           . "melpa-stable")
                           (ivy-hydra     . "melpa-stable")
                           (ivy-rich      . "melpa-stable")
                           (ivy-rtags     . "melpa-stable")
                           (json-mode     . "melpa-stable")
                           (magit         . "melpa-stable")
                           (magit-annex   . "melpa-stable")
                           (magit-popup   . "melpa-stable")
                           (markdown-mode . "melpa-stable")
                           (modalka       . "melpa-stable")
                           (org-pdfview   . "melpa-stable")
                           (pdf-tools     . "melpa-stable")
                           (undo-tree     . "melpa-stable")
                           (which-key     . "melpa-stable")
                           (yaml-mode     . "melpa-stable")))

(package-refresh-contents)
(package-install-selected-packages)
