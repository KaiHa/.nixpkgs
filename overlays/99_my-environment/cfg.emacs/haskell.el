(require 'haskell)

(define-key interactive-haskell-mode-map (kbd "C-c C-c") 'haskell-compile)

(setq
 dante-repl-command-line-methods '(impure-nix new-build bare bare-ghci)
 haskell-compile-cabal-build-alt-command "cd %s && mycabal new-clean && mycabal new-build --ghc-option=-ferror-spans"
 haskell-compile-cabal-build-command     "cd %s && mycabal new-build --ghc-option=-ferror-spans"
 haskell-hoogle-command "hoogle --count=60"
 haskell-mode-hook '(company-mode
                     ;; dante-mode
                     flycheck-haskell-setup
                     flycheck-mode
                     haskell-decl-scan-mode
                     haskell-indentation-mode
                     highlight-uses-mode
                     interactive-haskell-mode)
 haskell-process-log t
 haskell-process-path-cabal "mycabal"
 haskell-process-type 'auto)
