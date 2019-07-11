(require 'haskell)

(define-key interactive-haskell-mode-map (kbd "C-c C-c") 'haskell-compile)

(setq

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
 haskell-process-log t
 haskell-process-type 'auto)
