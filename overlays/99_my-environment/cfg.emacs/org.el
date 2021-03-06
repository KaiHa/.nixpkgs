(require 'org-msg)
(require 'org-protocol)
(eval-after-load 'org '(require 'org-pdftools))
(org-agenda-to-appt)

(defun kai/org-refile-targets ()
  `((,(seq-filter
       (lambda (f)
         (or
          (string-suffix-p "events.org" f)
          (string-suffix-p "notes.org" f)
          (string-suffix-p "notmuch.org" f)
          (string-suffix-p "Notizen.org" f)
          (string-suffix-p "tasks.org" f)
          (string-suffix-p "projects.org" f)))
       (org-agenda-files)) . (:level . 1))))

(defun kai/confirm-needed (lang code)
  (if (seq-contains '("latex") lang)
      nil
    t))

(setq
 org-agenda-files '("~/org/" "~/org/imported/" "~/org/shared/")
 org-agenda-include-diary t
 org-agenda-start-on-weekday 'nil
 org-agenda-sticky t
 org-agenda-time-grid '((today remove-match) (800 1200 1600) " - - -" "")
 org-agenda-window-setup 'other-window
 org-archive-file-header-format nil
 org-caldav-inbox "~/org/imported/caldav-inbox.org"
 org-capture-templates
      '(("a" "Action for clocked in task" entry (clock)
         "* %?%i\n  %U\n  %a")
        ("b" "Besorgung" checkitem (file+headline "~/org/inbox.org" "Besorgungen") )
        ("e" "Event" entry (file+headline "~/org/events.org" "Events")
         "* %i\n  %^t%?\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\n  Entered on %U\n  %i\n  %a")
        ("t" "Todo" entry (file "~/org/inbox.org")
         "* TODO %?\n%(if (> (length \"%i\") 0) \"  - %i\n\")%(if (> (length \"%a\") 0) \"  - %a\")"))
 org-catch-invisible-edits 'error
 org-confirm-babel-evaluate 'kai/confirm-needed
 org-default-notes-file "~/org/notes.org"
 org-fontify-done-headline t
 org-msg-default-alternatives '(html text)
 org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil"
 org-n-level-faces 1
 org-refile-targets (kai/org-refile-targets)
 org-stuck-projects '("project+LEVEL=1/-DONE" ("TODO" "NEXT") nil "")
 org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "DONE(d)" "CANCELED(c)")))

(org-babel-do-load-languages
 'org-babel-load-languages '((emacs-lisp . t)
                             (latex . t)
                             (shell . t)))

(org-link-set-parameters "tel")

(face-spec-set 'org-agenda-date-today '((t (:inverse-video t))))
(face-spec-set 'org-agenda-structure '((t (:foreground "steel blue"))))
(face-spec-set 'org-headline-done '((t (:foreground "gray" :weight normal))))
(face-spec-set 'org-level-1 '((t (:weight bold))))
