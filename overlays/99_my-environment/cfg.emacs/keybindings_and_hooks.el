(add-hook 'c++-mode-hook     'rtags-start-process-unless-running)
(add-hook 'c-mode-hook       'rtags-start-process-unless-running)
;;(add-hook 'haskell-mode-hook (lambda ()
;;                               (local-set-key (kbd "C-c C-c") 'haskell-compile)
;;                               (dante-mode)))
(add-hook 'prog-mode-hook    'hs-minor-mode)
(add-hook 'text-mode-hook    'auto-fill-mode)
(add-hook 'text-mode-hook    'flyspell-mode)
(add-hook 'view-mode-hook    'evil-motion-state)


;; custom key-bindings
(global-set-key (kbd "C-c a")   'org-agenda)
(global-set-key (kbd "C-c b")   'org-iswitchb)
(global-set-key (kbd "C-c c")   'org-capture)
(global-set-key (kbd "C-c l")   'org-store-link)

(global-set-key (kbd "C-s")     'swiper)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-x g")   'magit-status)
(global-set-key (kbd "C-x t")   (lambda () (interactive) (if truncate-lines (set 'truncate-lines nil) (set 'truncate-lines t))))

(global-set-key (kbd "M-/")     'hippie-expand)
(global-set-key (kbd "M-j")     'other-window)
(global-set-key (kbd "M-k")     (lambda () (interactive) (other-window -1)))
(global-set-key (kbd "M-x")     'counsel-M-x)

(define-key minibuffer-local-map (kbd "M-p") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "M-n") 'next-complete-history-element)
