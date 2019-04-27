(require 'haskell)

(define-key interactive-haskell-mode-map (kbd "C-c C-c") 'haskell-compile)

(setq

 dante-repl-command-line-methods '(bare bare-ghci)
 dante-repl-command-line-methods-alist
    '((bare .
            #[257 "\300\207"
                  [("cabal" "new-repl" dante-target "--builddir=dist/dante")]
                  2 "

(fn _)"])
      (bare-ghci .
                 #[257 "\300\207"
                       [("ghci")]
                       2 "

(fn _)"]))

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
