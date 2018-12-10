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
 calendar-longitude 10
 calendar-latitude 52
 calendar-mark-diary-entries-flag t
 calendar-week-start-day 1)

;;;; Faces ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(face-spec-set 'calendar-today '((t (:background "green" :underline nil :weight bold))))
