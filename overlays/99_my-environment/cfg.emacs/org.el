(require 'org-eww)
(require 'org-protocol)
(eval-after-load 'org '(require 'org-pdfview))
(org-agenda-to-appt)

(setq
 org-agenda-files '("~/.emacs.d/org")
 org-agenda-include-diary t
 org-agenda-start-on-weekday 1
 org-agenda-sticky t
 org-agenda-time-grid '((today remove-match) (800 1200 1600) " - - -" "")
 org-agenda-window-setup 'other-window
 org-caldav-inbox "~/org/imported/caldav-inbox.org"
 org-capture-templates
      '(("a" "Action for clocked in task" entry (clock)
         "* %?%i\n  %U\n  %a")
        ("e" "Event" entry (file+headline "~/.emacs.d/org/events.org" "Events")
         "* %i\n  %^t%?\n  %a")
        ("j" "Journal" entry (file+datetree "~/.emacs.d/org/journal.org")
         "* %?\n  Entered on %U\n  %i\n  %a")
        ("t" "Todo" entry (file+headline "~/.emacs.d/org/tasks.org" "Tasks")
         "* TODO %?\n  %i\n  %a"))
 org-catch-invisible-edits 'error
 org-default-notes-file "~/.emacs.d/org/notes.org"
 org-fontify-done-headline t
 org-n-level-faces 1)

(org-babel-do-load-languages
 'org-babel-load-languages '((emacs-lisp . t)
                             (shell . t)))

(face-spec-set 'org-agenda-structure '((t (:foreground "steel blue"))))
(face-spec-set 'org-headline-done '((t (:foreground "gray" :weight normal))))
(face-spec-set 'org-level-1 '((t (:weight bold))))
