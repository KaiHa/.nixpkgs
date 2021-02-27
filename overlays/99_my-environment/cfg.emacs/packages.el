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
                             bpftrace-mode
                             company-ghci
                             csv-mode
                             dictionary
                             dired-du
                             editorconfig
                             emms
                             emms-info-mediainfo
                             flycheck-rust
                             forecast
                             german-holidays
                             haskell-mode
                             hl-todo
                             htmlize
                             iedit
                             ivy-pass
                             json-mode
                             lsp-haskell
                             lsp-ivy
                             lsp-mode
                             lsp-treemacs
                             lsp-ui
                             lua-mode
                             magit
                             magit-annex
                             markdown-mode
                             nix-mode
                             noccur
                             ob-async
                             org-caldav
                             org-msg
                             org-pdfview
                             pdf-tools
                             rtags
                             rustic
                             sly
                             undo-tree
                             weechat
                             which-key
                             yaml-mode
                             yasnippet) ;; used by rustic

 package-pinned-packages '((bbdb-vcard      . "melpa")
                           (flycheck        . "melpa")
                           (german-holidays . "melpa")
                           (sly             . "melpa")))

;; Use the following commands to install the selected packages:
;;
;;  (package-refresh-contents)
;;  (package-install-selected-packages)
