(require 'org-eww)
(require 'org-protocol)
(eval-after-load 'org '(require 'org-pdfview))
(org-agenda-to-appt)

(setq
 org-agenda-files '("~/.emacs.d/org")
 org-agenda-include-diary t
 org-agenda-start-on-weekday 1
 org-agenda-sticky t
 org-agenda-time-grid '((daily today remove-match)
                        (800 1200 1600)
                        " - - -" "----------------")
 org-agenda-window-setup 'other-window
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

(defcustom org-icalendar-import-file
  (expand-file-name "~/.emacs.d/org/events.org")
  "The path of the file in which imported icalender events will be saved."
  :type 'file)

(defcustom org-icalendar-import-template
  "
** %s
   :PROPERTIES:
   :LINK: %l
   :ID: %i
   :END:
   %t
   @%p
*** Description
%d"
  "Template for the import of icalender events. The following
placeholders can be used:
  %s SUMMARY
  %l link to the source of this event
  %i ID
  %t timestamp
  %p location (mnemonic place)
  %d description"
  :type 'string)

(defun org-icalendar-import (&optional org-link)
  "Import iCalendar events from current buffer.

This function searches the current buffer for the first iCalendar
object, reads it and adds all VEVENT elements to the
`org-icalendar-import-file'."
  (interactive)
  (let ((events (org-icalendar-convert org-link)))
    (if events
        (progn
          (with-current-buffer
              (find-file-noselect org-icalendar-import-file)
            (save-excursion
              (goto-char (point-max))
              (insert events)))
          t)
      nil)))

(defun org-icalendar-convert (&optional org-link)
  "Convert all iCalendar events from current buffer.

This function searches the current buffer for the first iCalendar
object, reads it and returns all VEVENT elements as a string
accoring to the `org-icalendar-import-template'."
  (interactive)
  (save-current-buffer
    ;; prepare ical
    (set-buffer (icalendar--get-unfolded-buffer (current-buffer)))
    (goto-char (point-min))
    (if (re-search-forward "^BEGIN:VCALENDAR\\s-*$" nil t)
        (let* ((ical-contents (progn (beginning-of-line)
                                     (icalendar--read-element nil nil)))
               ical-errors
               events
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
                                   (if desc desc ""))))
                   (location (icalendar--convert-string-for-import
                              (let ((loc (icalendar--get-event-property e 'LOCATION)))
                                (if loc loc ""))))
                   (rrule (icalendar--get-event-property e 'RRULE))
                   (rdate (icalendar--get-event-property e 'RDATE))
                   (uid   (icalendar--get-event-property e 'UID))
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
              (setq events (concat events
                                   (format-spec
                                    org-icalendar-import-template
                                    `((?s . ,summary)
                                      (?l . ,(if org-link org-link ""))
                                      (?i . ,uid)
                                      (?t . ,(org-icalendar--dt-to-timestamp dtstart-dec dtend-dec))
                                      (?p . ,location)
                                      (?d . ,description)))))))
          events)

      (message "Current buffer does not contain iCalendar contents!")
      nil)))

(ert-deftest org-icalendar-convert-test ()
  (letf ((org-icalendar-import-template "** %s
   :PROPERTIES:
   :LINK: %l
   :ID: %i
   :END:
   %t
   @%p
*** Description
%d"))
    (should (equal (with-temp-buffer
                     (insert "BEGIN:VCALENDAR
PRODID:-//Posteo Webmail//NONSGML Calendar//EN
VERSION:2.0
X-WR-Timezone: Europe/London
BEGIN:VEVENT
CATEGORIES:Keine
DTEND;VALUE=DATE:20190916
DTSTAMP:20190914T184452Z
DTSTART;VALUE=DATE:20190914
SEQUENCE:1568486692
SUMMARY:Wochenende
LOCATION;CHARSET=UTF-8:Somewhere\, Some Place 2
UID:17ccf6eec15d84a8c8e6cb4a54f3db0a-baFWgfj
END:VEVENT
END:VCALENDAR
")
                     (org-icalendar-convert "[[https://example.org][Goto source]]"))
                   "** Wochenende
   :PROPERTIES:
   :LINK: [[https://example.org][Goto source]]
   :ID: 17ccf6eec15d84a8c8e6cb4a54f3db0a-baFWgfj
   :END:
   <2019-09-14>--<2019-09-15>
   @Somewhere, Some Place 2
*** Description
"))))

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
  (should (equal (org-icalendar--dt-to-timestamp '(0 0  0 28 1 2019 0 t 7200) '(0 0  0  1 2 2019 0 t 7200)) "<2019-01-28>--<2019-01-31>"))
  (should (equal (org-icalendar--dt-to-timestamp '(0 0 17 28 1 2019 0 t 7200))                              "<2019-01-28 17:00>"))
  (should (equal (org-icalendar--dt-to-timestamp '(0 0 17 28 1 2019 0 t 2700) '(0 0 19 28 1 2019 0 t 7200)) "<2019-01-28 17:00-19:00>"))
  (should (equal (org-icalendar--dt-to-timestamp '(0 0 17 28 1 2019 0 t 2700) '(0 0  2 29 1 2019 0 t 7200)) "<2019-01-28 17:00>--<2019-01-29 02:00>")))

(defun org-icalendar-import-from-notmuch-message ()
  "Import iCalendar events from the current message."
  (interactive)
  (let* ((id (notmuch-show-get-message-id)))
    (with-temp-buffer
      "*org-icalender-import-message*"
      (erase-buffer)
      (let ((coding-system-for-read 'no-conversion))
        (call-process notmuch-command nil t nil "show" "--format=raw" id))
      (goto-char (point-min))
      (let ((calendar (mm-get-part
                       (mm-find-part-by-type
                        (nconc (list (mm-dissect-buffer t nil)) nil) "text/calendar" nil t))))
        (erase-buffer)
        (insert calendar)
        (org-icalendar-import (concat "[[notmuch:" id "][Invitation Email]]"))))))
