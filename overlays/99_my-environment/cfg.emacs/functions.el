(defun mysecret-open-file (fpath)
  "Open FILE and decrypt it."
  (interactive "Ffilename: ")
  (let ((buf (generate-new-buffer
	      (concat (file-name-nondirectory fpath) ".tmp"))))
    (mysecret--crypt
     (concat "-d -o - " fpath)
     buf)
    (pop-to-buffer buf)))


(defun mysecret-write-file (fpath)
  "Encrypt current buffer and write it to FILE."
  (interactive "Ffilename: ")
  (mysecret--crypt
   (concat "-e -o " fpath " -")
   (current-buffer)))


(defun mysecret--crypt (args buf)
  (letrec ((secret
	    (string-trim
	     (shell-command-to-string
	      "gpg --decrypt /home/kai/.config/nixpkgs/secret.gpg 2> /dev/null")
	     "[\"]+"
	     "[\n\"]+"))
	   (cmd (concat "aescrypt  -p " secret " " args)))
    (shell-command-on-region (point-min) (point-max) cmd buf)))


(defun fix-diary-dates ()
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

