(require 'dired-x)
(require 'hideshow)
(require 'iedit)
(require 'nxml-mode)
(require 'sgml-mode)
(blink-cursor-mode)
(column-number-mode t)
(global-hl-todo-mode)
(global-undo-tree-mode)
(menu-bar-mode t)
(pdf-tools-install)
(savehist-mode)
(set-scroll-bar-mode nil)
(show-paren-mode)
(tool-bar-mode -1)
(which-key-mode)
(winner-mode)

(setenv "DBUS_SESSION_BUS_ADDRESS" (with-temp-buffer
                                     (insert-file-contents "/home/kai/.dbus-session-bus-address")
                                     (string-trim (buffer-string))))
(setenv "GDK_BACKEND" "wayland")

(put 'narrow-to-region 'disabled nil)

(set-display-table-slot standard-display-table 'truncation (make-glyph-code ?$  'error))
(set-display-table-slot standard-display-table 'wrap       (make-glyph-code ?\\ 'error))

(setq-default indent-tabs-mode nil)

(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>][^>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"
               "<!--"
               sgml-skip-tag-forward
               nil))

(defface hs-ov-face
  '((t (:slant italic :height 0.8 :background "#dfa" :box t)))
  "Face to hightlight the ... area of hidden regions"
  :group 'hideshow)

(setq hs-set-up-overlay
      (lambda  (ov)
        (when (eq 'code (overlay-get ov 'hs))
          (let ((mymarker "+")
                (mystring (format "...(%d)"
                                  (count-lines (overlay-start ov)
                                               (overlay-end ov)))))
            (put-text-property 0 1 'display '(left-fringe empty-line hs-ov-face) mymarker)
            (overlay-put ov 'before-string mymarker)
            (put-text-property 0 (length mystring) 'face 'hs-ov-face mystring)
            (overlay-put ov 'display mystring)))))

(setq
 browse-url-browser-function 'eww-browse-url
 browse-url-generic-program "firefox"
 dired-du-size-format ","
 dired-omit-files "^\\.?#\\|^\\.[^.]"

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

 image-dired-cmd-rotate-original-options '("%o" "-rotate" "%d" "%t")
 image-dired-cmd-rotate-original-program "convert"

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
 scroll-preserve-screen-position t
 shr-inhibit-images t
 shr-image-animate nil
 tramp-default-proxies-alist '(("\\.fritz\\.box" "\\`root\\'" "/ssh:%h:"))
 visible-bell t)


;; reloading of frames (must happen after setting frame-background-mode)
(mapc 'frame-set-background-mode (frame-list))

;;;; Faces ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(face-spec-set 'tty-menu-enabled-face  '((t (:foreground "black" :weight normal))))
(face-spec-set 'default                '((t (:family "Hack" :foundry "bitstream" :slant normal :weight normal :height 98 :width normal))))
(face-spec-set 'font-lock-comment-face '((t (:foreground "dim gray" :slant italic))))
(face-spec-set 'mode-line              '((t (:background "#fbb" :foreground "black" :box (:line-width 2 :color "#fbb")))))
(face-spec-set 'mode-line-inactive     '((t (:background "#fff" :inherit mode-line  :box (:line-width 2 :color "#fbb")))))
(face-spec-set 'line-number-current-line '((t (:foreground "magenta" :weight bold))))
