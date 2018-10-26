(add-hook 'calendar-today-visible-hook 'calendar-mark-today)

(setq
 calendar-intermonth-header '(propertize
                              "KW"
                              'face '('italic '(:foreground "blue")))
 calendar-intermonth-text   '(propertize
                              (format "%2d"
                                      (car (calendar-iso-from-absolute
                                            (calendar-absolute-from-gregorian
                                             (list month day year)))))
                              'face '('italic '(:foreground "blue")))
 calendar-week-start-day 1)

;;;; Faces ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(face-spec-set 'calendar-today '((t (:background "green" :underline nil :weight bold))))
