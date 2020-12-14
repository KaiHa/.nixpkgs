(require 's)
(require 'magit)

(defun kai/encrypted-file-open (fpath)
  "Open FILE and decrypt it."
  (interactive "Ffilename: ")
  (let ((buf (generate-new-buffer
              (concat (file-name-nondirectory fpath) ".tmp"))))
    (kai/encrypted-file--crypt
     (concat "-d -o - " fpath)
     buf)
    (pop-to-buffer buf)))


(defun kai/encrypted-file-write (fpath)
  "Encrypt current buffer and write it to FILE."
  (interactive "Ffilename: ")
  (kai/encrypted-file--crypt
   (concat "-e -o " fpath " -")
   (current-buffer)))


(defun kai/encrypted-file--crypt (args buf)
  (letrec ((secret
            (string-trim
             (shell-command-to-string
              "gpg --decrypt /home/kai/.config/nixpkgs/secret.gpg 2> /dev/null")
             "[\"]+"
             "[\n\"]+"))
           (cmd (concat "aescrypt  -p " secret " " args)))
    (shell-command-on-region (point-min) (point-max) cmd buf)))


(defun kai/fix-diary-dates ()
  "Change dates like 2019/01/30 to Jan 30, 2019"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^\\(20[0-9][0-9]\\)\\/\\([0-9]+\\)\\/\\([0-9]+\\)" nil t)
      (replace-match (concat
                      (pcase (match-string 2)
                        ((or "1" "01") "Jan")
                        ((or "2" "02") "Feb")
                        ((or "3" "03") "Mar")
                        ((or "4" "04") "Apr")
                        ((or "5" "05") "May")
                        ((or "6" "06") "Jun")
                        ((or "7" "07") "Jul")
                        ((or "8" "08") "Aug")
                        ((or "9" "09") "Sep")
                        (   "10"       "Oct")
                        (   "11"       "Nov")
                        (   "12"       "Dec"))
                      " \\3, \\1")))))


(defun kai/eww-toggle-images ()
  "Toggle whether images are loaded and reload the current page fro cache."
  (interactive)
  (setq-local shr-inhibit-images (not shr-inhibit-images))
  (eww-reload t)
  (message "Images are now %s"
           (if shr-inhibit-images "off" "on")))


(defun kai/ssh-auth-sock-set (sock)
  "Set the environment variable SSH_AUTH_SOCK"
  (interactive "fssh auth sock: ")
  (setenv "SSH_AUTH_SOCK" sock))

(defun kai/insert-random-hex (count)
  "Insert a random hex value of length 32.
Call `universal-argument' before for different count."
  (interactive "P")
  (let* ((charset "0123456789abcdef")
         (baseCount (length charset))
         (n (if (numberp count) (abs count) 32)))
    (dotimes (_ n)
      (insert (elt charset (random baseCount))))))

(defun kai/insert-random-string (count)
  "Insert a random alphanumerics string of length 16.
The possible chars are: A to Z, a to z, 0 to 9, _, +, -, =.
Call `universal-argument' before for different count."
  (interactive "P")
  (let* ((charset "_+-=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789")
         (baseCount (length charset))
         (n (if (numberp count) (abs count) 16)))
    (dotimes (_ n)
      (insert (elt charset (random baseCount))))))

(defun kai/command-line-diff (switch)
  (let ((a (pop command-line-args-left))
        (b (pop command-line-args-left)))
    (ediff a b)))

(add-to-list 'command-switch-alist '("diff" . kai/command-line-diff))

(defun kai/bbdb-import-posteo-vcards ()
  (interactive)
  (seq-do (lambda (r) (bbdb-delete-record-internal r t))
          (bbdb-records))
  (seq-do 'bbdb-vcard-import-file
          (file-expand-wildcards "~/.contacts.posteo/default/*.vcard"))
  (bbdb-save))


(defun kai/sort-posteo-vcards ()
  "Sort the fields of the VCards in ~/.contacts.posteo alphabetically."
  (interactive)
  (seq-do (lambda (a)
            (let ((buf (find-file-noselect a)))
              (with-current-buffer buf
                (goto-char (point-min))
                (let ((beg (progn
                             (search-forward "BEGIN:VCARD")
                             (match-end 0)))
                      (end (progn
                             (search-forward "END:VCARD")
                             (match-beginning 0))))
                  (sort-lines nil beg end))
                (save-buffer))
                (kill-buffer buf)))
          (file-expand-wildcards "~/.contacts.posteo/default/*.vcard")))

(defun kai/theme-toggle (&optional theme)
  "Toggle color theme. Optional argument theme can be either `light' or `dark'."
  (interactive)
  (let ((next (or theme (if (eq (car custom-enabled-themes) 'tango-dark)
                            'light
                          'dark))))
    (if (eq next 'light)
        (progn
          (setq custom-enabled-themes '()
                frame-background-mode 'light)
          (load-theme 'tango t))
      (setq custom-enabled-themes '()
            frame-background-mode 'dark)
      (load-theme 'tango-dark t)))
  (mapc 'frame-set-background-mode (frame-list)))


(defun kai/cfw:open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "IndianRed")
    (cfw:cal-create-source "Orange")
    (cfw:ical-create-source
     "posteo"
     (with-temp-buffer
       (seq-do 'insert-file-contents
               (file-expand-wildcards "~/.calendar.posteo/**/*.ics"))
       (let ((filepath (concat "/tmp/" (buffer-hash) ".ics")))
         (write-region nil nil filepath)
         filepath))
     "ForestGreen"))))

(defun kai/org-import-posteo-calendar ()
  "Import an icalendar file."
  (interactive)
  (if (equal (call-process "vdirsyncer" nil nil nil "sync") 0)
      (let* ((org-caldav-inbox "~/org/imported/posteo.org")
             (inbox-buffer (find-file-noselect org-caldav-inbox)))
        (with-current-buffer inbox-buffer
          (erase-buffer)
          (insert "#+FILETAGS: :posteo:\n#+CATEGORY: 📆\n\n"))
        (seq-do (lambda (f)
                  (with-temp-buffer
                    (insert-file-contents f)
                    (kai/rfc2425-unfold-buffer)
                    (goto-char (point-min))
                    (org-caldav-import-ics-buffer-to-org)
                    (with-current-buffer inbox-buffer
                      (goto-char (point-max))
                      (insert "  Imported from [[file://" f "][here]].\n"))))
                (file-expand-wildcards "~/.calendar.posteo/**/*.ics"))
        (with-current-buffer inbox-buffer (save-buffer)))
    (message "Sync of Posteo calendar failed (`vdirsyncer sync' returned exit code ≠ 0)")))


(defun kai/org-import-notmuch-calendar ()
  "Import iCalendar events from the current message."
  (interactive)
  (let* ((id (notmuch-show-get-message-id))
         (org-caldav-inbox '(file+headline "~/org/notmuch.org" "Imported from Notmuch"))
         (inbox-buffer (find-file-noselect "~/org/notmuch.org")))
    (with-temp-buffer
      (let ((coding-system-for-read 'no-conversion))
        (call-process notmuch-command nil t nil "show" "--format=raw" id))
      (goto-char (point-min))
      (let ((calendar (mm-get-part
                       (mm-find-part-by-type
                        (nconc (list (mm-dissect-buffer t nil)) nil) "text/calendar" nil t))))
        (erase-buffer)
        (insert calendar)
        (kai/rfc2425-unfold-buffer)
        (goto-char (point-min))
        (org-caldav-import-ics-buffer-to-org)
        (with-current-buffer inbox-buffer
          (goto-char (point-max))
          (insert "  [[notmuch:" id "][Invitation Email]]")
          (save-buffer))))))

(defun kai/rfc2425-unfold-buffer ()
  (goto-char (point-min))
  (while (re-search-forward "\n\\( \\|\t\\)" nil t)
    (replace-match "")))

(defun kai/org-fetch-shadow-files ()
  (interactive)
  (let ((default-directory (expand-file-name "~/org/")))
    (if (magit-anything-unstaged-p)
        (message "kai/org-fetch-shadow-files: you have unstaged changes in %s" default-directory)
      (seq-do (lambda (f)
                (copy-file f
                           (s-replace "/var/lib/syncthing/org-files/"
                                      "./"
                                      (s-replace "/var/lib/syncthing/nina-kai/"
                                                 "./shared/"
                                                 f))
                           t))
              (cl-concatenate 'list
                              (file-expand-wildcards "/var/lib/syncthing/org-files/*.org")
                              (file-expand-wildcards "/var/lib/syncthing/nina-kai/*.org"))))))

(defun kai/org-patch-shadow-file ()
  "Patch the shadow file."
  (let* ((patch-file (make-temp-file "owh-"))
         (shadow-file (s-replace (expand-file-name "~/org/")
                                 "/var/lib/syncthing/org-files/"
                                 (s-replace (expand-file-name "~/org/shared/")
                                            "/var/lib/syncthing/nina-kai/"
                                            (buffer-file-name))))
         (new (diff-file-local-copy (current-buffer))))
    (when (file-exists-p shadow-file)
      (call-process "diff" nil (list :file patch-file) nil "-u" (buffer-file-name) new)
      (with-temp-buffer
        (call-process "patch" nil t nil "--no-backup-if-mismatch" "--reject-file=-" shadow-file patch-file)
        (message (buffer-string)))))
  ;; This function must return nil! Because it is in the `write-file-functions'.
  nil)
