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
