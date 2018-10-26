(historian-mode)
(ivy-historian-mode)
(ivy-mode)
(ivy-rich-mode)

(setq
 ivy-count-format "(%d/%d) "
 ivy-rich-path-style 'abbrev
 ivy-sort-matches-functions-alist '((t . ivy--prefix-sort)
				    (ivy-switch-buffer . ivy-sort-function-buffer))
 ivy-use-virtual-buffers t)

;;;; Faces ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(face-spec-set 'ivy-current-match           '((t (:background "yellow"))))
;;(face-spec-set 'ivy-minibuffer-match-face-1 '((t (:foreground "orange" :weight bold))))
;;(face-spec-set 'ivy-minibuffer-match-face-2 '((t (:foreground "orange"))))
;;(face-spec-set 'ivy-minibuffer-match-face-3 '((t (:foreground "orange"))))
;;(face-spec-set 'ivy-minibuffer-match-face-4 '((t (:foreground "orange"))))
