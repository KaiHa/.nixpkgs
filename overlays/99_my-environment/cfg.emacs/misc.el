(column-number-mode t)
(global-hl-todo-mode)
(global-undo-tree-mode)
(menu-bar-mode t)
(pdf-tools-install)
(savehist-mode)
(set-scroll-bar-mode nil)
(show-paren-mode)
(tool-bar-mode -1)
(winner-mode)

(set-display-table-slot standard-display-table 'truncation (make-glyph-code ?$  'error))
(set-display-table-slot standard-display-table 'wrap       (make-glyph-code ?\\ 'error))

(setq-default indent-tabs-mode nil)

(setq
 browse-url-browser-function 'eww-browse-url
 browse-url-generic-program "firefox"

 ediff-merge-split-window-function 'split-window-vertically
 ediff-split-window-function       'split-window-horizontally
 ediff-window-setup-function       'ediff-setup-windows-plain

 explicit-shell-file-name "/run/current-system/sw/bin/bash"
 frame-background-mode 'light
 frame-title-format '(:eval (if (buffer-file-name) "Emacs %f" "Emacs %b"))
 gnutls-verify-error t

 help-window-select t
 hs-hide-comments-when-hiding-all nil
 ispell-dictionary "en_US"
 ;;inhibit-startup-screen t

 magit-diff-refine-hunk t
 mailcap-user-mime-data '(((viewer . pdf-view-mode)
                           (type   . "application/pdf"))
                          ((viewer . image-mode)
                           (type   . "image/jpeg")))
 mouse-yank-at-point t

 password-cache-expiry 300
 read-file-name-completion-ignore-case t
 require-final-newline t
 user-full-name "Kai Harries"
 user-mail-address "kai.harries@gmail.com"

 safe-local-variable-values '((bug-reference-bug-regexp . "\\(\\(?:[Ii]ssue \\|[Ff]ixe[ds] \\|[Rr]esolve[ds]? \\|[Cc]lose[ds]? \\|[Pp]\\(?:ull [Rr]equest\\|[Rr]\\) \\|(\\)#\\([0-9]+\\))?\\)"))
 shr-blocked-images ".*"
 tramp-default-proxies-alist '(("\\.fritz\\.box" "\\`root\\'" "/ssh:%h:")))


;; reloading of frames (must happen after setting frame-background-mode)
(mapc 'frame-set-background-mode (frame-list))

;;;; Faces ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(face-spec-set 'tty-menu-disabled-face '((t (:background "blue" :foreground "lightgray"))))
(face-spec-set 'tty-menu-enabled-face  '((t (:background "blue" :foreground "black"))))
(face-spec-set 'default                '((t (:family "Hack" :foundry "bitstream" :slant normal :weight normal :height 98 :width normal))))
(face-spec-set 'font-lock-comment-face '((t (:foreground "dim gray" :slant italic))))
(face-spec-set 'mode-line              '((t (:background "#fbb" :foreground "black" :box (:line-width 2 :color "#fbb")))))
(face-spec-set 'mode-line-inactive     '((t (:background "#fff" :inherit mode-line  :box (:line-width 2 :color "#fbb")))))
(face-spec-set 'hs-face                '((t (:background "#ff8" :slant italic :height 0.8))))
(face-spec-set 'hs-fringe-face         '((t (:background "#ff8" :foreground "#888"))))
(face-spec-set 'whitespace-space       '((t (:foreground "lightgray"))))
