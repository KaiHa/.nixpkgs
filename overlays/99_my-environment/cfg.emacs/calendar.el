(require 'calfw-cal)
(require 'german-holidays)

(add-hook 'calendar-today-visible-hook 'calendar-mark-today)
(add-hook 'diary-list-entries-hook 'diary-include-other-diary-files)
(add-hook 'diary-list-entries-hook 'diary-sort-entries t)
(add-hook 'diary-mark-entries-hook 'diary-mark-included-diary-files)

(appt-activate t)

(setq
 appt-audible t
 appt-display-mode-line t
 calendar-date-style 'iso
 calendar-holidays holiday-german-NI-holidays

 calendar-intermonth-header '(propertize
                              "KW"
                              'face '(italic (:foreground "blue")))
 calendar-intermonth-text   '(propertize
                              (format "%2d"
                                      (car (calendar-iso-from-absolute
                                            (calendar-absolute-from-gregorian
                                             (list month day year)))))
                              'face '(italic (:foreground "blue")))
 calendar-mark-diary-entries-flag t
 calendar-week-start-day 1)

;;;; Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun ical-concat-files (target-file files)
  (with-temp-file target-file
    (mapcar 'insert-file-contents files)
    (goto-char (point-min))
    (while (re-search-forward "END:VCALENDAR.*\nBEGIN:VCALENDAR.*\n" nil t)
      (replace-match ""))))

(defun ical-concat-files-in-dir (dir target-file)
  (interactive "Dical source directory: \nFdestination file: ")
  (ical-concat-files
   target-file
   (directory-files dir t "\\.ics" t)))

;;;; Faces ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(face-spec-set 'calendar-today '((t (:background "green" :underline nil :weight bold))))
