(require 'org-eww)
(require 'org-notmuch "~/.config/emacs/org-notmuch.el")
(require 'org-protocol)

(setq
 org-agenda-files '("~/org")
 org-agenda-include-diary t
 org-babel-load-languages '((emacs-lisp . t) (shell . t))
 org-capture-templates
      '(("b" "Bookmark" entry (file+headline "~/org/notes.org" "Bookmarks")
         "* %?%i\n  %a")
        ("e" "Event" entry (file+headline "~/org/events.org" "Events")
         "* %i\n  %^t%?\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")
        ("t" "Todo" entry (file+headline "~/org/tasks.org" "Tasks")
         "* TODO %?\n  %i\n  %a"))
 org-catch-invisible-edits 'error
 org-default-notes-file "~/org/notes.org"
 org-fontify-done-headline t)
