;;;; Definition of functions used below ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ispell-select-dict-de_de ()
  "Switch ispell dictionary to de_DE"
  (interactive)
  (ispell-change-dictionary "de_DE"))

(defun ispell-select-dict-en_us ()
  "Switch ispell dictionary to en_US"
  (interactive)
  (ispell-change-dictionary "en_US"))

(defun line-number-relative-toggle ()
  "Toggle display of relative line-numbers on/off"
  (interactive)
  (if (equal display-line-numbers 'relative)
      (setq display-line-numbers nil)
    (setq display-line-numbers 'relative)))

;;;; Hooks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'eww)
(add-hook 'c++-mode-hook      'rtags-start-process-unless-running)
(add-hook 'c-mode-hook        'rtags-start-process-unless-running)
(add-hook 'emacs-startup-hook 'org-agenda-to-appt)
(add-hook 'midnight-mode-hook 'org-agenda-to-appt)
(add-hook 'nxml-mode-hook     'hs-minor-mode)
(add-hook 'prog-mode-hook     'hs-minor-mode)
(add-hook 'text-mode-hook     'auto-fill-mode)
(add-hook 'text-mode-hook     'flyspell-mode)
(add-hook 'pdf-view-mode-hook
	  (lambda ()
	    (define-key pdf-view-mode-map    (kbd "C-s") 'isearch-forward-regexp)))

(setq eww-after-render-hook
      (lambda ()
        (if (string-prefix-p "https://www.heise.de/" (eww-current-url))
            (if shr-inhibit-images (eww-readable)))))

;;;; File extension <-> modes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

;;;; Custom key-bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c a")   'org-agenda)
(global-set-key (kbd "C-c b")   'org-iswitchb)
(global-set-key (kbd "C-c c")   'org-capture)
(global-set-key (kbd "C-c d d") 'ispell-select-dict-de_de)
(global-set-key (kbd "C-c d e") 'ispell-select-dict-en_us)
(global-set-key (kbd "C-c l")   'org-store-link)
(global-set-key (kbd "C-c L")   'org-insert-link-global)
(global-set-key (kbd "C-c n")   'line-number-relative-toggle)
(global-set-key (kbd "C-c o")   'org-open-at-point-global)
(global-set-key (kbd "C-c s")   'swiper)
(global-set-key (kbd "C-c <S-return>") 'browse-url-xdg-open)

(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "C-x g")   'magit-status)
(global-set-key (kbd "C-x t")   'toggle-truncate-lines)

(global-set-key (kbd "M-/")     'hippie-expand)
(global-set-key (kbd "M-i")     'counsel-imenu)
(global-set-key (kbd "M-j")     'next-multiframe-window)
(global-set-key (kbd "M-k")     'previous-multiframe-window)
(global-set-key (kbd "M-x")     'counsel-M-x)


(define-key eww-mode-map         (kbd "I")   #'my/eww-toggle-images)
(define-key eww-link-keymap      (kbd "I")   #'my/eww-toggle-images)

(define-key minibuffer-local-map (kbd "M-p") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "M-n") 'next-complete-history-element)

