(require 'haskell)

(define-key interactive-haskell-mode-map (kbd "C-c C-c") 'haskell-compile)

(setq
 haskell-hoogle-command "hoogle --count=60"
 haskell-mode-hook '(lsp)
 haskell-process-log t
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
