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
                             dictionary
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
                             org-gcal
                             org-pdfview
                             pdf-tools
                             rtags
                             rust-mode
                             ;;scion
                             undo-tree
                             which-key
                             yaml-mode)
 package-pinned-packages '((async         . "melpa-stable")
                           (calfw         . "melpa-stable")
                           (calfw-cal     . "melpa-stable")
                           (company       . "melpa-stable")
                           (counsel       . "melpa-stable")
                           (dante         . "melpa-stable")
                           (dash          . "melpa-stable")
                           (dictionary    . "melpa-stable")
                           (editorconfig  . "melpa-stable")
                           (elfeed        . "melpa-stable")
                           (epl           . "melpa-stable")
                           (f             . "melpa-stable")
                           (flycheck      . "melpa-stable")
                           (flycheck-haskell . "melpa-stable")
                           (ghub          . "melpa-stable")
                           (git-commit    . "melpa-stable")
                           (graphql       . "melpa-stable")
                           (haskell-mode  . "melpa-stable")
                           (hl-todo       . "melpa-stable")
                           (hydra         . "melpa-stable")
                           (iedit         . "melpa-stable")
                           (ivy           . "melpa-stable")
                           (ivy-hydra     . "melpa-stable")
                           (ivy-rich      . "melpa-stable")
                           (ivy-rtags     . "melpa-stable")
                           (json-mode     . "melpa-stable")
                           (json-reformat . "melpa-stable")
                           (json-snatcher . "melpa-stable")
                           (lcr           . "melpa-stable")
                           (nix-mode      . "melpa-stable")
                           (magit         . "melpa-stable")
                           (magit-annex   . "melpa-stable")
                           (magit-popup   . "melpa-stable")
                           (markdown-mode . "melpa-stable")
                           (modalka       . "melpa-stable")
                           (org-gcal      . "melpa-stable")
                           (org-pdfview   . "melpa-stable")
                           (pdf-tools     . "melpa-stable")
                           (pkg-info      . "melpa-stable")
                           (rtags         . "melpa-stable")
                           (rust-mode     . "melpa-stable")
                           (s             . "melpa-stable")
                           (swiper        . "melpa-stable")
                           (tablist       . "melpa-stable")
                           (treepy        . "melpa-stable")
                           (undo-tree     . "melpa-stable")
                           (which-key     . "melpa-stable")
                           (with-editor   . "melpa-stable")
                           (yaml-mode     . "melpa-stable")))

(package-refresh-contents)
(package-install-selected-packages)
