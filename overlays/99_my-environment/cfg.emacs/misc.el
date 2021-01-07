(require 'bbdb)
(require 'bbdb-com)
(require 'bbdb-snarf)
(require 'emms-setup)
(require 'emms-info-mediainfo)
(require 'dired-x)
(require 'hideshow)
(require 'iedit)
(require 'nxml-mode)
(require 'sgml-mode)
(bbdb-initialize)
(blink-cursor-mode)
(column-number-mode t)
(editorconfig-mode 1)
(electric-pair-mode)
(emms-all)
(emms-default-players)
(add-to-list 'emms-info-functions 'emms-info-mediainfo)
(global-hl-todo-mode)
(global-undo-tree-mode)
(icomplete-mode)
(menu-bar-mode t)
(midnight-mode t)
(minibuffer-electric-default-mode)
(pdf-tools-install)
(random t)
(savehist-mode)
(set-scroll-bar-mode nil)
(show-paren-mode)
(temp-buffer-resize-mode)
(tool-bar-mode -1)
(which-key-mode)
(windmove-default-keybindings)
(winner-mode)

(let
 ((f (expand-file-name "~/.dbus-session-bus-address")))
 (if (file-exists-p f)
     (setenv "DBUS_SESSION_BUS_ADDRESS" (with-temp-buffer
                                          (insert-file-contents f)
                                          (string-trim (buffer-string))))))
(setenv "GDK_BACKEND" "wayland")

(put 'narrow-to-region 'disabled nil)

(set-display-table-slot standard-display-table 'truncation (make-glyph-code ?$  'error))
(set-display-table-slot standard-display-table 'wrap       (make-glyph-code ?\\ 'error))

(setq-default indent-tabs-mode nil
              indicate-buffer-boundaries 'left
              indicate-empty-lines t
              notmuch-show-indent-content nil) ;; indentation seems to be slow

(add-to-list 'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>][^>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"
               "<!--"
               sgml-skip-tag-forward
               nil))

(add-to-list 'bbdb-snarf-rule-alist
             '(ah-vz-pdf
               bbdb-snarf-surrounding-space
               bbdb-snarf-name
               (lambda (record)
                 (re-search-forward "^v\n/\\(.*\\)" nil t)
                 (bbdb-record-set-field record 'aka (match-string 1) t t)
                 (replace-match ""))
               (lambda (record)
                 (re-search-forward "^\\* \\(.*\\)" nil t)
                 (bbdb-record-set-field record 'birthday (match-string 1) nil t)
                 (replace-match ""))
               (lambda (_record)
                 (re-search-forward "^[12][90][0-9][0-9]/[0-9]* [WS]S\nAH ...\\. [12][90][0-9][0-9] " nil t)
                 (replace-match ""))
               bbdb-snarf-empty-lines
               bbdb-snarf-address-eu
               (lambda (rec) (bbdb-snarf-phone-eu rec "^T: \\([0-9 ]*\\)"))
               (lambda (rec) (bbdb-snarf-phone-eu rec "^H: \\([0-9 ]*\\)"))
               bbdb-snarf-mail))

(add-to-list 'completion-styles 'flex t)

(defface hs-ov-face
  '((t (:slant italic :height 0.8 :background "#8a5" :box t)))
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
 bbdb-phone-style nil
 bbdb-vcard-try-merge nil
 browse-url-browser-function 'browse-url-firefox
 browse-url-generic-program "firefox"
 default-input-method "german-postfix"

 dired-create-destination-dirs 'ask
 dired-du-size-format ","
 dired-listing-switches "-alh"
 dired-omit-files "^\\.?#\\|^\\.[^.]"
 dired-vc-rename-file t
 wdired-allow-to-change-permissions t

 ediff-merge-split-window-function 'split-window-vertically
 ediff-split-window-function       'split-window-horizontally
 ediff-window-setup-function       'ediff-setup-windows-plain

 emms-source-file-default-directory "~/Media/"

 explicit-shell-file-name "/run/current-system/sw/bin/bash"
 frame-background-mode 'light
 frame-title-format '(:eval (if (buffer-file-name) "Emacs %f" "Emacs %b"))
 gnutls-verify-error t

 help-window-select t
 hs-hide-comments-when-hiding-all nil
 httpd-host "localhost"
 httpd-port 49080
 ispell-dictionary "en_US"
 inhibit-startup-screen t

 image-dired-cmd-rotate-original-options '("%o" "-rotate" "%d" "%t")
 image-dired-cmd-rotate-original-program "convert"

 lsp-ui-doc-delay 2
 lsp-ui-doc-position 'top

 magit-diff-refine-hunk t
 mailcap-user-mime-data '(((viewer . pdf-view-mode)
                           (type   . "application/pdf"))
                          ((viewer . image-mode)
                           (type   . "image/jpeg")))
 mml-secure-openpgp-sign-with-sender t
 mouse-yank-at-point t

 password-cache-expiry 300
 read-buffer-completion-ignore-case t
 read-file-name-completion-ignore-case t
 show-paren-delay 0.5
 show-paren-style 'mixed
 shr-external-browser 'browse-url-generic
 shr-use-fonts nil ;; proportional fonts seem to make notmuch-show slow
 shr-width 100
 user-full-name "Kai Harries"
 user-mail-address "kai.harries@posteo.de"

 safe-local-variable-values '((bug-reference-bug-regexp . "\\(\\(?:[Ii]ssue \\|[Ff]ixe[ds] \\|[Rr]esolve[ds]? \\|[Cc]lose[ds]? \\|[Pp]\\(?:ull [Rr]equest\\|[Rr]\\) \\|(\\)#\\([0-9]+\\))?\\)"))
 scroll-preserve-screen-position t
 show-trailing-whitespace t
 shr-inhibit-images t
 shr-image-animate nil
 tramp-default-proxies-alist '(("\\.fritz\\.box" "\\`root\\'" "/ssh:%h:"))
 vc-follow-symlinks t
 view-read-only t
 visible-bell t)


;; reloading of frames (must happen after setting frame-background-mode)
(mapc 'frame-set-background-mode (frame-list))

(add-hook 'tex-mode-hook
          (lambda ()
            (add-to-list 'tex-compile-commands '("zathura %r.pdf &" "%r.pdf"))))

;; Set font for emojis and symbols, e.g.:
;;   🎂 🔋 🔌 💾 🔔 🔕
(add-hook 'before-make-frame-hook
          (lambda ()
            (set-fontset-font t '(#x2400 . #x1fbff) (font-spec :family "Noto Color Emoji"))))

;;;; Faces ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(face-spec-set 'default                  '((t (:family "Hack" :foundry "bitstream" :slant normal :weight normal :height 98 :width normal))))
(face-spec-set 'mode-line                '((t (:background "#fbb" :foreground "#2e3436" :box (:line-width 2 :style released-button)))))
(face-spec-set 'mode-line-inactive       '((t (:background "#888a85" :foreground "#2e3436" :box (:line-width 2 :color "#888a85")))))
(face-spec-set 'line-number-current-line '((t (:foreground "magenta" :weight bold))))
(face-spec-set 'region '((t (:background "sky blue" :weight bold))))
(face-spec-set 'font-lock-comment-face '((t (:slant italic))))

;; (load-theme 'tango t)
