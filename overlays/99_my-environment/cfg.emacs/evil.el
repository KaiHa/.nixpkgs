(setq evil-want-C-i-jump nil)

(evil-mode)

(delete 'git-commit-mode evil-emacs-state-modes)
(delete 'help-mode       evil-motion-state-modes)
(delete 'info-mode       evil-motion-state-modes)

(setq
 evil-emacs-state-modes (append evil-emacs-state-modes
                                '(diary-mode
                                  elfeed-search-mode
                                  elfeed-show-mode
                                  eww-mode
                                  forecast-mode
                                  image-dired-display-image-mode
                                  image-dired-thumbnail-mode
                                  image-mode
                                  info-mode
                                  help-mode
                                  nix-ls-gen-mode))

 evil-motion-state-modes (append evil-motion-state-modes
                                 '()))
