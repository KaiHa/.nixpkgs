;;;; Hooks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'c++-mode-hook     'rtags-start-process-unless-running)
(add-hook 'c-mode-hook       'rtags-start-process-unless-running)
(add-hook 'prog-mode-hook    'hs-minor-mode)
(add-hook 'text-mode-hook    'auto-fill-mode)
(add-hook 'text-mode-hook    'flyspell-mode)
(add-hook 'view-mode-hook    'evil-motion-state)
(add-hook 'pdf-view-mode-hook
	  (lambda ()
	    (define-key pdf-view-mode-map    "j"         'pdf-view-next-line-or-next-page)
	    (define-key pdf-view-mode-map    "k"         'pdf-view-previous-line-or-previous-page)
	    (define-key pdf-view-mode-map    (kbd "C-s") 'isearch-forward-regexp)))

(setq eww-after-render-hook
      (lambda ()
        (if (string-prefix-p "https://www.heise.de/" (eww-current-url))
            (eww-readable))))

;;;; File extension <-> modes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

;;;; Custom key-bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c a")   'org-agenda)
(global-set-key (kbd "C-c b")   'org-iswitchb)
(global-set-key (kbd "C-c c")   'org-capture)
(global-set-key (kbd "C-c l")   'org-store-link)
(global-set-key (kbd "C-c <S-return>") 'browse-url-xdg-open)

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

