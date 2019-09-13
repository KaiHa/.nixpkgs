(require 'org-eww)
(require 'org-notmuch "~/.config/emacs/org-notmuch.el")
(require 'org-protocol)
(eval-after-load 'org '(require 'org-pdfview))
(org-agenda-to-appt)

(setq
 org-agenda-files '("~/.emacs.d/org")
 org-agenda-include-diary t
 org-agenda-start-on-weekday 1
 org-agenda-time-grid '((daily today remove-match)
                        (800 1200 1600)
                        " - - -" "----------------")
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
 org-fontify-done-headline t)

(org-babel-do-load-languages
 'org-babel-load-languages '((emacs-lisp . t)
                             (shell . t)))

(face-spec-set 'org-agenda-current-time '((t (:inherit org-time-grid :slant italic :weight bold :background "dark magenta" :foreground "green"))))
(face-spec-set 'org-agenda-structure '((t (:foreground "steel blue"))))
(face-spec-set 'org-time-grid '((t (:foreground "dark gray"))))


(defun org-icalendar-import (&optional outfile)
  "Extract iCalendar events from current buffer.

This function searches the current buffer for the first iCalendar
object, reads it and adds all VEVENT elements to the outfile."
  (interactive)
  (save-current-buffer
    ;; prepare ical
    (set-buffer (icalendar--get-unfolded-buffer (current-buffer)))
    (goto-char (point-min))
    (if (re-search-forward "^BEGIN:VCALENDAR\\s-*$" nil t)
        (let* ((ical-contents (progn (beginning-of-line)
                                     (icalendar--read-element nil nil)))
               ical-errors
               (ev (icalendar--all-events ical-contents))
               (zone-map (icalendar--convert-all-timezones ical-contents)))
          (while ev
            (setq e (car ev))
            (setq ev (cdr ev))
            (let* ((dtstart (icalendar--get-event-property e 'DTSTART))
                   (dtstart-zone (icalendar--find-time-zone
                                  (icalendar--get-event-property-attributes
                                   e 'DTSTART)
                                  zone-map))
                   (dtstart-dec (icalendar--decode-isodatetime dtstart nil
                                                               dtstart-zone))
                   (dtend (icalendar--get-event-property e 'DTEND))
                   (dtend-zone (icalendar--find-time-zone
                                (icalendar--get-event-property-attributes
                                 e 'DTEND)
                                zone-map))
                   (dtend-dec (icalendar--decode-isodatetime dtend
                                                             nil dtend-zone))
                   (summary (icalendar--convert-string-for-import
                             (or (icalendar--get-event-property e 'SUMMARY)
                                 "No summary")))
                   (description (icalendar--convert-string-for-import
                                 (let ((desc (icalendar--get-event-property e 'DESCRIPTION)))
                                   (if desc
                                       (format "   %s\n" desc)
                                     ""))))
                   (location (icalendar--convert-string-for-import
                              (let ((loc (icalendar--get-event-property e 'LOCATION)))
                                (if loc
                                    (format "   @%s\n" loc)
                                  ""))))
                   (rrule (icalendar--get-event-property e 'RRULE))
                   (rdate (icalendar--get-event-property e 'RDATE))
                   (duration (icalendar--get-event-property e 'DURATION)))
              (when duration
                (let ((dtend-dec-d (icalendar--add-decoded-times
                                    dtstart-dec
                                    (icalendar--decode-isoduration duration))))
                  (if (and dtend-dec (not (eq dtend-dec dtend-dec-d)))
                      (message "Inconsistent endtime and duration for %s"
                               summary))
                  (setq dtend-dec dtend-dec-d)))
              ;; write event to org-file
              (with-current-buffer
                  (find-file-noselect "/home/kai/.emacs.d/org/events.org")
                (save-excursion
                  (goto-char (point-max))
                  (insert (format "\n** %s\n   %s\n%s%s"
                                  summary
                                  (org-icalendar--dt-to-timestamp dtstart-dec dtend-dec)
                                  location
                                  description))))))
          t)

      (message "Current buffer does not contain iCalendar contents!")
      nil)))

(defun org-icalendar--dt-to-timestamp (dtstart &optional dtend)
  (pcase (list dtstart dtend)
    (`((0  0  0  ,D ,M ,Y ,_ ,_ ,_) nil)                               (format "<%d-%02d-%02d>" Y M D))
    (`((,_ ,m ,h ,D ,M ,Y ,_ ,_ ,_) nil)                               (format "<%d-%02d-%02d %02d:%02d>" Y M D h m))
    (`((0  0  0  ,D ,M ,Y ,_ ,_ ,_) (0  0   0   ,_  ,_  ,_  ,_ ,_ ,_))
     (pcase (decode-time (time-subtract (apply 'encode-time dtend) (seconds-to-time 1)))
       (`(,_ ,_ ,_ ,D2 ,M2 ,Y2 ,_ ,_ ,_) (format "<%d-%02d-%02d>--<%d-%02d-%02d>" Y M D Y2 M2 D2))))
    (`((,_ ,m ,h ,D ,M ,Y ,_ ,_ ,_) (,_ ,m2 ,h2 ,D2 ,M2 ,Y2 ,_ ,_ ,_))
     (if (and (eq D D2) (eq M M2) (eq Y Y2))
         (format "<%d-%02d-%02d %02d:%02d-%02d:%02d>" Y M D h m h2 m2)
       (format "<%d-%02d-%02d %02d:%02d>--<%d-%02d-%02d %02d:%02d>" Y M D h m Y2 M2 D2 h2 m2)))))

(ert-deftest org-icalendar--dt-to-timestamp-test ()
  (should (equal (org-icalendar--dt-to-timestamp '(0 0  0 14 9 2019 0 t 7200))                              "<2019-09-14>"))
  (should (equal (org-icalendar--dt-to-timestamp '(0 0  0 28 3 2019 0 t 7200) '(0 0  0  1 4 2019 0 t 7200)) "<2019-03-28>--<2019-03-31>"))
  (should (equal (org-icalendar--dt-to-timestamp '(0 0 17 28 3 2019 0 t 7200))                              "<2019-03-28 17:00>"))
  (should (equal (org-icalendar--dt-to-timestamp '(0 0 17 28 3 2019 0 t 2700) '(0 0 19 28 3 2019 0 t 7200)) "<2019-03-28 17:00-19:00>"))
  (should (equal (org-icalendar--dt-to-timestamp '(0 0 17 28 3 2019 0 t 2700) '(0 0  2 29 3 2019 0 t 7200)) "<2019-03-28 17:00>--<2019-03-29 02:00>")))
