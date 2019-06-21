(require 'org-eww)
(require 'org-notmuch "~/.config/emacs/org-notmuch.el")
(require 'org-protocol)
(eval-after-load 'org '(require 'org-pdfview))
(org-agenda-to-appt)

(setq
 org-agenda-files '("~/.emacs.d/org")
 org-agenda-include-diary t
 org-agenda-start-on-weekday 1
 org-agenda-time-grid '((daily today)
                        (800 1200 1600)
                        " - - -" "----------------")
 org-babel-load-languages '((emacs-lisp . t) (shell . t))
 org-capture-templates
      '(("b" "Bookmark" entry (file+headline "~/.emacs.d/org/notes.org" "Bookmarks")
         "* %?%i\n  %a")
        ("e" "Event" entry (file+headline "~/.emacs.d/org/events.org" "Events")
         "* %i\n  %^t%?\n  %a")
        ("j" "Journal" entry (file+datetree "~/.emacs.d/org/journal.org")
         "* %?\n  Entered on %U\n  %i\n  %a")
        ("t" "Todo" entry (file+headline "~/.emacs.d/org/tasks.org" "Tasks")
         "* TODO %?\n  %i\n  %a"))
 org-catch-invisible-edits 'error
 org-default-notes-file "~/.emacs.d/org/notes.org"
 org-fontify-done-headline t)

(face-spec-set 'org-agenda-current-time '((t (:inherit org-time-grid :slant italic :weight bold :background "dark magenta" :foreground "green"))))
(face-spec-set 'org-agenda-structure '((t (:foreground "steel blue"))))
(face-spec-set 'org-time-grid '((t (:foreground "dark gray"))))
