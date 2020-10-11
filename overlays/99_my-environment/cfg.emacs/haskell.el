(require 'haskell)

(define-key interactive-haskell-mode-map (kbd "C-c C-c") 'haskell-compile)

(setq
 dante-repl-command-line-methods '(impure-nix new-build bare bare-ghci)
 haskell-compile-cabal-build-alt-command "cd %s && mycabal new-clean && mycabal new-build --ghc-option=-ferror-spans"
 haskell-compile-cabal-build-command     "cd %s && mycabal new-build --ghc-option=-ferror-spans"
 haskell-hoogle-command "hoogle --count=60"
 haskell-mode-hook '(lsp)
 haskell-process-log t
 haskell-process-path-cabal "mycabal"
 haskell-process-type 'auto
 lsp-haskell-server-wrapper-function
   (lambda
     (argv)
     (append
      (append
       (list "nix-shell" "-I" "." "--command")
       (list
        (mapconcat ’identity argv " ")))
      (list
       (concat
        (lsp-haskell--get-root)
        "/shell.nix")))))
