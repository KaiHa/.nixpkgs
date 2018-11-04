(require 'haskell)

(define-key interactive-haskell-mode-map (kbd "C-c C-c") 'haskell-compile)

(setq
 dante-mode-hook '(ignore-default-nix)
 haskell-compile-cabal-build-alt-command "cd %s && cabal clean -s && cabal new-build --ghc-option=-ferror-spans"
 haskell-compile-cabal-build-command     "cd %s &&                   cabal new-build --ghc-option=-ferror-spans"
 haskell-mode-hook '(company-mode
		     dante-mode
		     flycheck-haskell-setup
		     flycheck-mode
		     haskell-decl-scan-mode
		     haskell-indentation-mode
		     highlight-uses-mode
		     interactive-haskell-mode)
 haskell-process-type 'cabal-new-repl)

(defun ignore-default-nix ()
  "Ignore the default.nix file when deciding which `repl` should be used for Dante."
  (add-to-list
   'dante-repl-command-line-methods-alist
   `(nix
     . ,(lambda (root)
	  (dante-repl-by-file
	   root
	   '("shell.nix")
           '("nix-shell" "--pure" "--run" (concat "cabal repl " (or dante-target "") " --builddir=dist/dante"))))))
  (add-to-list
   'dante-repl-command-line-methods-alist
   `(impure-nix
     . ,(lambda (root)
	  (dante-repl-by-file
	   root
	   '("shell.nix")
           '("nix-shell" "--run" (concat "cabal repl " (or dante-target "") " --builddir=dist/dante")))))))
