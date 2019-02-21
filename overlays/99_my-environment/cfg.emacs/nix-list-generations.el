(defvar nix-ls-gen-mode-hook nil)
(defvar nix-ls-gen--gen-regex "\\([0-9]+\\) +20..-..-.. +..:..:..")

(defun nix-list-generations ()
  "List all nix generations"
  (interactive)
  (with-current-buffer-window
   "*nix-list-generations*" nil nil
   (let ((profiles (append
                    '("/nix/var/nix/profiles/system")
                    (if (file-directory-p "/nix/var/nix/profiles/system-profiles/")
                        (directory-files "/nix/var/nix/profiles/system-profiles/" t "^[^.]"))
                    (mapcar (lambda (x) (concat x "/profile"))
                            (directory-files "/nix/var/nix/profiles/per-user/" t "^[^.]"))
                    (mapcar (lambda (x) (concat x "/channels"))
                            (directory-files "/nix/var/nix/profiles/per-user/" t "^[^.]")))))
     (pop-to-buffer-same-window "*nix-list-generations*")
     (cd "/sudo::/")
     (mapcar (lambda (x)
               (let ((gens (shell-command-to-string (format "sudo nix-env -p %s --list-generations | cat" x))))
                 (insert (format "%s:\n%s\n" x gens))))
             profiles))
   (deactivate-mark)
   (nix-ls-gen-mode)))


(defun nix-ls-gen--rm-marked-gens ()
  "Delete the Nix generation marked by the region."
  (interactive)
  (if (use-region-p)
      (letrec
          ((region (string-trim-right (buffer-substring (region-beginning) (region-end))))
           (gens (if (string-match-p nix-ls-gen--gen-regex region)
                     (mapconcat 'identity
                                (mapcar
                                 (lambda (x) (car (split-string x)))
                                 (split-string region "\n+"))
                                " ")))
           (profile (save-excursion
                      (re-search-backward "^\\(/.*\\):")
                      (match-string 1))))
        (if (and gens profile)
            (if (yes-or-no-p (format "Delete generations %s of profile '%s'? " gens profile))
                (progn
                  (shell-command (format "sudo nix-env --delete-generations %s -p %s" gens profile))
                  (nix-list-generations)))
          (message "no generation that can be deleted in region")))))


(defun nix-ls-gen--rm-gen-at-point ()
  "Delete the Nix generation at point."
  (interactive)
  (let ((gen (if (string-match-p nix-ls-gen--gen-regex (thing-at-point 'line t))
                 (car (split-string (thing-at-point 'line t)))))
        (profile (save-excursion
                   (re-search-backward "^\\(/.*\\):")
                   (match-string 1))))
    (if (and gen profile)
        (if (yes-or-no-p (format "Delete generation %s of profile '%s'? " gen profile))
            (progn
              (shell-command (format "sudo nix-env --delete-generations %s -p %s" gen profile))
              (nix-list-generations)))
      (message "no generation that can be deleted at point"))))


(defun nix-ls-gen--rm-gens ()
  "Delete the selected Nix generations (either selected by point or region)."
  (interactive)
  (if (use-region-p)
      (nix-ls-gen--rm-marked-gens)
    (nix-ls-gen--rm-gen-at-point)))


(defvar nix-ls-gen-mode-map
  (let ((map (make-keymap)))
    (define-key map (kbd "k")   'nix-ls-gen--rm-gens)
    (define-key map (kbd "p")   'nix-ls-gen--prev-gen)
    (define-key map (kbd "n")   'nix-ls-gen--next-gen)
    (define-key map (kbd "G")   'nix-list-generations)
    (define-key map (kbd "c")   'nix-ls-gen--collect-garbage)
    (define-key map (kbd "SPC") 'set-mark-command)
    map)
  "Keymap for nix-ls-gen major mode")


(defun nix-ls-gen--next-gen ()
  "Move point to the next generation."
  (interactive)
  (end-of-line)
  (if (use-region-p)
      (progn
        (forward-line)
        (if (not (string-match-p nix-ls-gen--gen-regex (thing-at-point 'line t)))
            (forward-line -1))
        (if (> (point) (region-beginning))
            (end-of-line)
          (beginning-of-line)))
    (re-search-forward nix-ls-gen--gen-regex)
    (beginning-of-line)))


(defun nix-ls-gen--prev-gen ()
  "Move point to the previous generation."
  (interactive)
  (beginning-of-line)
  (if (use-region-p)
      (progn
        (forward-line -1)
        (if (not (string-match-p nix-ls-gen--gen-regex (thing-at-point 'line t)))
            (forward-line))
        (if (> (point) (region-beginning))
            (end-of-line)
          (beginning-of-line)))
    (re-search-backward nix-ls-gen--gen-regex)
    (beginning-of-line)))


(defun nix-ls-gen--collect-garbage ()
  "Run the nix garbage collection."
  (interactive)
  (if (yes-or-no-p "Collect garbage? ")
      (async-shell-command "nix-collect-garbage")))


(define-derived-mode nix-ls-gen-mode special-mode "nix-ls-gen"
  "Major mode for listing Nix generations."
  (interactive)
  (kill-all-local-variables)
  ;;(set-syntax-table nix-ls-gen-mode-syntax-table)
  (use-local-map nix-ls-gen-mode-map)
  ;;(set (make-local-variable 'font-lock-defaults) '(nix-ls-gen-font-lock-keywords))
  ;;(set (make-local-variable 'indent-line-function) 'nix-ls-gen-indent-line)
  (setq major-mode 'nix-ls-gen-mode)
  (setq mode-name "nix-ls-gen")
  (hl-line-mode)
  (run-hooks 'nix-ls-gen-mode-hook))

(provide 'nix-ls-gen-mode)
