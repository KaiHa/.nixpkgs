(require 'org-eww)
(require 'org-protocol)
(eval-after-load 'org '(require 'org-pdfview))
(org-agenda-to-appt)

(defun kai/org-refile-targets ()
  `((,(seq-filter
       (lambda (f)
         (or
          (string-suffix-p "notes.org" f)
          (string-suffix-p "Notizen.org" f)
          (string-suffix-p "tasks.org" f)
          (string-suffix-p "projects.org" f)))
       (org-agenda-files)) . (:level . 1))))

(setq
 org-agenda-files '("~/org/" "~/org/imported/" "~/org/shared/")
 org-agenda-include-diary t
 org-agenda-start-on-weekday 1
 org-agenda-sticky t
 org-agenda-time-grid '((today remove-match) (800 1200 1600) " - - -" "")
 org-agenda-window-setup 'other-window
 org-archive-file-header-format nil
 org-caldav-inbox "~/org/imported/caldav-inbox.org"
 org-capture-templates
      '(("a" "Action for clocked in task" entry (clock)
         "* %?%i\n  %U\n  %a")
        ("e" "Event" entry (file+headline "~/org/events.org" "Events")
         "* %i\n  %^t%?\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\n  Entered on %U\n  %i\n  %a")
        ("t" "Todo" entry (file "~/org/inbox.org")
         "* TODO %?\n  %i\n  %a"))
 org-catch-invisible-edits 'error
 org-default-notes-file "~/org/notes.org"
 org-fontify-done-headline t
 org-n-level-faces 1
 org-refile-targets (kai/org-refile-targets)
 org-todo-keywords '((sequence "TODO" "WAITING" "|" "DONE" "CANCELED")))

(org-babel-do-load-languages
 'org-babel-load-languages '((emacs-lisp . t)
                             (shell . t)))

(face-spec-set 'org-agenda-structure '((t (:foreground "steel blue"))))
(face-spec-set 'org-headline-done '((t (:foreground "gray" :weight normal))))
(face-spec-set 'org-level-1 '((t (:weight bold))))
