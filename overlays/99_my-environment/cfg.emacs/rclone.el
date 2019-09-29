(defvar rclone-remote "gcrypt:")

(defun rclone-sync (src dest)
  "Use rclone to copy src to dest. Create/extract a tar-ball if only dest/src end with tar.xz."
  (interactive)
  (let ((src  (if (string-match-p ":" src ) src  (expand-file-name src)))
        (dest (if (string-match-p ":" dest) dest (expand-file-name dest)))
        (tmpdir (make-temp-file "rclone" t)))
    (cl-flet ((mktarname (path) (concat tmpdir "/" (cdr (rclone--split-path path)))))
      (rclone--log (format "(rclone-sync %s %s) started..." src dest))
      (cond ((and (string-match-p ".tar.xz$" src)
                  (not (string-match-p ".tar.xz$" dest)))
             (make-directory dest t)
             (rclone--call "rclone" "sync" src tmpdir)
             (rclone--call "tar" "-xf" (mktarname src) "-C" dest))
            ((and (not (string-match-p ".tar.xz$" src))
                  (string-match-p ".tar.xz$" dest))
             (rclone--call "tar" "-cJf" (mktarname dest) "-C" (car (rclone--split-path src)) (cdr (rclone--split-path src)))
             (rclone--call "rclone" "sync" (mktarname dest) (car (rclone--split-path dest))))
            (t (rclone--call "rclone" "sync" src dest)))
      (rclone--log "done")))
  (message "rclone-sync finished see buffer *rclone-sync* for details."))


(defun rclone--log (msg)
  (let ((buf (get-buffer-create "*rclone-sync*")))
    (with-current-buffer buf
      (goto-char (point-max))
      (princ (format "[%s] %s\n" (format-time-string "%T") msg) buf))))

(defun rclone--call (program &rest args)
  (apply 'call-process program nil (get-buffer-create "*rclone-sync*") t args))

(defun rclone--split-path (path)
  "Split the path into a pair (DIR . FILENAME)."
  (string-match "^\\(.+[:/]\\)\\(.+\\)$" path)
  `(,(match-string 1 path) . ,(match-string 2 path)))


(defun my-upload-emacs.d ()
  "Upload the emacs.d directory into the cloud."
  (interactive)
  (rclone-sync "~/.emacs.d/.git" "gcrypt:emacs.d.git.tar.xz"))


(defun my-download-emacs.d ()
  "Download the emacs.d directory from the cloud."
  (interactive)
  (rclone--call  "rm" "-rf" (expand-file-name "~/.cloud-sync/emacs.d"))
  (rclone-sync "gcrypt:emacs.d.git.tar.xz" "~/.cloud-sync/emacs.d")
  (cl-letf ((default-directory "~/.emacs.d/"))
    (magit-fetch-other
     (concat "file://" (expand-file-name "~/.cloud-sync/emacs.d/.git"))
     nil)
    (magit-merge-plain "FETCH_HEAD" nil t)))


(defun my-download-all ()
  "Download everything from the cloud."
  (interactive)
  (my-download-elfeed-db)
  (my-download-emacs.d))

(defun my-upload-all ()
  "Upload everything from the cloud."
  (interactive)
  (my-upload-elfeed-db)
  (my-upload-emacs.d))
