(require 'flyspell)
(require 'gnus-dired)

;;;; Definition of functions used below ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun insert-date (&optional n)
  "Insert the current date at point.
With a prefix arg N add an offset of N days to the current date."
  (interactive "P")
  (if n
      (insert (format-time-string "%Y-%m-%d"
                                  (time-add
                                   (current-time)
                                   (* 86400
                                      (prefix-numeric-value n)))))
    (insert (format-time-string "%Y-%m-%d"))))

(defun ispell-select-dict-de_de ()
  "Switch ispell dictionary to de_DE"
  (interactive)
  (ispell-change-dictionary "de_DE")
  (activate-input-method "german-postfix"))

(defun ispell-select-dict-en_us ()
  "Switch ispell dictionary to en_US"
  (interactive)
  (ispell-change-dictionary "en_US")
  (activate-input-method 'nil))

(defun line-number-relative-toggle ()
  "Toggle display of relative line-numbers on/off"
  (interactive)
  (if (equal display-line-numbers 'relative)
      (setq display-line-numbers nil)
    (setq display-line-numbers 'relative)))

(defun browse-url-generic-toggle-program ()
  "Toggle the default (external) browser between firefox and tor-browser."
  (interactive)
  (if (equal browse-url-generic-program "firefox")
      (setq browse-url-generic-program "tor-browser")
    (setq browse-url-generic-program "firefox"))
  (message "browser changed to %s" browse-url-generic-program))

(defun text-scale-up ()
  "Make the text bigger."
  (text-scale-increase 1))

(defun emms-play-url-at-point ()
  "Play the url found at point in emms."
  (interactive)
  (emms-play-url (shr-url-at-point nil)))

(defun emms-add-url-at-point ()
  "Add the url found at point to emms playlist."
  (interactive)
  (emms-add-url (shr-url-at-point nil)))

(defun kai/set-active-theme ()
  (with-temp-buffer
    (insert-file-contents
     (expand-file-name "~/.config/gtk-3.0/settings.ini"))
    (goto-char (point-min))
    (re-search-forward "gtk-application-prefer-dark-theme *= *\\(true\\|false\\)")
    (let* ((dark (match-string 1)))
      (if (equal dark "true")
          (kai/theme-toggle 'dark)
        (kai/theme-toggle 'light)))))

;;;; Hooks ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'eww)
(add-hook 'after-init-hook         'global-company-mode)
(add-hook 'server-after-make-frame-hook 'kai/set-active-theme)
(add-hook 'c++-mode-hook           'rtags-start-process-unless-running)
(add-hook 'c-mode-hook             'rtags-start-process-unless-running)
(add-hook 'dired-mode-hook         'gnus-dired-mode)
(add-hook 'emacs-startup-hook      'org-agenda-to-appt)
(add-hook 'midnight-hook           'org-agenda-to-appt)
(add-hook 'nxml-mode-hook          'hs-minor-mode)
(add-hook 'prog-mode-hook          'hs-minor-mode)
(add-hook 'text-mode-hook          'auto-fill-mode)
(add-hook 'text-mode-hook          'flyspell-mode)
(add-hook 'pdf-view-mode-hook
	  (lambda ()
	    (define-key pdf-view-mode-map    (kbd "C-s") 'isearch-forward-regexp)))

(add-hook 'org-mode-hook
          (lambda ()
            (make-local-variable 'write-file-functions)
            (add-to-list 'write-file-functions 'kai/org-patch-shadow-file)
            (org-indent-mode)
            (require 'ob-async)))

(setq eww-after-render-hook
      (lambda ()
        (if (string-prefix-p "https://www.heise.de/" (eww-current-url))
            (if shr-inhibit-images (eww-readable)))))

(add-to-list 'delete-frame-functions
             (lambda (_frame)
               (let ((default-directory (expand-file-name "~/org/")))
                 (magit-stage-1 "-u")
                 (magit-commit-create (list "-m" (concat "Update of " (format-time-string "%A %F %T")))))))

;;;; File extension <-> modes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))

;;;; Custom key-bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c a")   'org-agenda)
(global-set-key (kbd "C-c b")   'org-switchb)
(global-set-key (kbd "C-c c")   'org-capture)
(global-set-key (kbd "C-c d d") 'ispell-select-dict-de_de)
(global-set-key (kbd "C-c d e") 'ispell-select-dict-en_us)
(global-set-key (kbd "C-c l")   'org-store-link)
(global-set-key (kbd "C-c L")   'org-insert-link-global)
(global-set-key (kbd "C-c n")   'line-number-relative-toggle)
(global-set-key (kbd "C-c o")   'org-open-at-point-global)
(global-set-key (kbd "C-c p")   'ivy-pass)
(global-set-key (kbd "C-c s")   'swiper)
(global-set-key (kbd "C-c .")   'insert-date)
(global-set-key (kbd "C-c <S-return>") 'browse-url-generic)
(global-set-key (kbd "C-c <C-return>") 'browse-url-generic-toggle-program)

(global-set-key (kbd "C-x B")   'bury-buffer)
(global-set-key (kbd "C-x g")   'magit-status)
(global-set-key (kbd "C-x t")   'toggle-truncate-lines)

(global-set-key (kbd "C-M-i")   'company-complete-common)
(global-set-key (kbd "M-/")     'hippie-expand)
(global-set-key (kbd "M-i")     'imenu)
(global-set-key (kbd "C-s-;")   'windmove-right)
(global-set-key (kbd "C-s-j")   'windmove-left)
(global-set-key (kbd "C-s-l")   'windmove-up)
(global-set-key (kbd "C-s-k")   'windmove-down)

(define-key eww-mode-map         (kbd "I")   #'kai/eww-toggle-images)
(define-key eww-link-keymap      (kbd "I")   #'kai/eww-toggle-images)

(define-key flyspell-mode-map (kbd "C-;") nil)

(define-key minibuffer-local-map (kbd "M-p") 'previous-complete-history-element)
(define-key minibuffer-local-map (kbd "M-n") 'next-complete-history-element)
(define-key minibuffer-local-map (kbd "M-P") 'previous-line-or-history-element)
(define-key minibuffer-local-map (kbd "M-N") 'next-line-or-history-element)
