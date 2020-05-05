(require 'generic)

(defvar kai/rfc2425-mode-hook nil)

(defvar kai/rfc2425-mode-map
  (let ((map (make-keymap)))
    (define-key map (kbd "<M-tab>") 'company-complete)
    map)
  "Keymap for kai/rfc2425 major mode")

(defun kai/rfc2425-mode-init ()
  (use-local-map kai/rfc2425-mode-map)
  (make-local-variable 'paragraph-start)
  (make-local-variable 'kai/rfc2425-mode-completion-list)
  (pcase (file-name-extension (buffer-file-name))
    ((or "vcard" "vcf")
     (setq paragraph-start "BEGIN:VCARD")
     (setq kai/rfc2425-mode-completion-list
           '("ADR;CHARSET=UTF-8;TYPE=HOME:" "ADR;CHARSET=UTF-8;TYPE=WORK:" "ADR;TYPE=HOME:" "ADR;TYPE=WORK:"
             "BDAY:" "BDAY;VALUE=DATE:"
             "BEGIN:VCARD\n"
             "CATEGORIES:"
             "EMAIL;TYPE=HOME:" "EMAIL;TYPE=INTERNET:" "EMAIL;TYPE=WORK:"
             "END:VCARD\n"
             "FN:"
             "N:"
             "NICKNAME:"
             "NOTE:"
             "ORG:" "ORG;CHARSET=UTF-8:"
             "PHOTO:"
             "TEL;TYPE=CELL:" "TEL;TYPE=HOME:" "TEL;TYPE=WORK:"
             "TITLE;CHARSET=UTF-8:"
             "UID:"
             "URL;TYPE=WORK:"
             "VERSION:3.0\n")))
    ("ics"
     (setq paragraph-start "BEGIN:VCALENDAR")
     (setq kai/rfc2425-mode-completion-list
           '("BEGIN:VCALENDAR\n"
             "BEGIN:VEVENT\n"
             "DTEND;VALUE=DATE:"
             "DTSTART;VALUE=DATE:"
             "END:VCALENDAR\n"
             "END:VEVENT\n"
             "SUMMARY:"
             "UID:"
             "VERSION:2.0\n")))
    (_
     (setq kai/rfc2425-mode-completion-list '())))
  (company-mode)
  (add-to-list 'company-backends 'company-rfc2425-backend)
  (run-hooks 'kai/rfc2425-mode-hook))

(define-generic-mode kai/rfc2425-mode
  '()
  nil
  '(("^BEGIN:.*" . font-lock-function-name-face)
    ("^END:.*"   . font-lock-function-name-face)
    (";[^:\n]+:" . font-lock-type-face)
    ("^\\([^;:\n]+\\):?" . font-lock-keyword-face))
  '("\\.\\(vcf\\|vcard\\|ics\\)\\'")
  '(kai/rfc2425-mode-init)
  "Generic mode for rfc2425 directory information files.")

(provide 'kai/rfc2425-mode)

(defun company-rfc2425-backend (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (case command
    (interactive (company-begin-backend 'company-rfc2425-backend))
    (prefix     (word-at-point))
    (candidates (seq-filter (lambda (a) (string-prefix-p arg a t))
                            kai/rfc2425-mode-completion-list))
    (meta (format "This value is named %s" arg))))
