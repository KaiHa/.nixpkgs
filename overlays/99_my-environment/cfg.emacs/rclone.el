(defvar rclone-remote "gcrypt:")

(defun rclone-sync (src dest)
  "Use rclone to copy src to dest. Create/extract a tar-ball if only dest/src end with tar.xz."
  (interactive)
  (let ((src  (if (string-match-p ":" src ) src  (expand-file-name src)))
        (dest (if (string-match-p ":" dest) dest (expand-file-name dest)))
        (tmpdir (make-temp-file "rclone" t))
        (buf (get-buffer-create "*rclone-sync*")))
    (cl-flet ((mktarname (path) (concat tmpdir "/" (cdr (rclone--split-path path))))
              (call (program &rest args) (apply 'call-process program nil buf t args))
              (logt (msg)
                    (with-current-buffer buf
                      (goto-char (point-max))
                      (princ (format "[%s] %s\n" (format-time-string "%T") msg) buf))))
      (logt (format "(rclone-sync %s %s) started..." src dest))
      (cond ((and (string-match-p ".tar.xz$" src)
                  (not (string-match-p ".tar.xz$" dest)))
             (make-directory dest t)
             (call "rclone" "sync" src tmpdir)
             (call "tar" "-xf" (mktarname src) "-C" dest))
            ((and (not (string-match-p ".tar.xz$" src))
                  (string-match-p ".tar.xz$" dest))
             (call "tar" "-cJf" (mktarname dest) "-C" (car (rclone--split-path src)) (cdr (rclone--split-path src)))
             (call "rclone" "sync" (mktarname dest) (car (rclone--split-path dest))))
            (t (call "rclone" "sync" src dest)))
      (logt "done")))
  (message "rclone-sync finished see buffer *rclone-sync* for details."))


(defun rclone--split-path (path)
  "Split the path into a pair (DIR . FILENAME)."
  (string-match "^\\(.+[:/]\\)\\(.+\\)$" path)
  `(,(match-string 1 path) . ,(match-string 2 path)))


(defun my-password-store-upload ()
  "Upload the password-store into the cloud."
  (interactive)
  (rclone-sync "~/.password-store/.git" "gcrypt:password-store.git.tar.xz"))


(defun my-password-store-download ()
  "Download the password-store from the cloud."
  (interactive)
  (shell-command "rm -rf ~/.cloud-sync/.password-store")
  (rclone-sync "gcrypt:password-store.git.tar.xz" "~/.cloud-sync/password-store")
  (cl-letf ((default-directory "~/.password-store/"))
    (magit-fetch-other
     (concat "file://" (expand-file-name "~/.cloud-sync/password-store/.git"))
     nil)
    (magit-merge-plain "FETCH_HEAD" nil t)))
