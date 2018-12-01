(evil-mode)

(delete 'git-commit-mode evil-emacs-state-modes)

(setq
 evil-emacs-state-modes (append evil-emacs-state-modes
                                '(elfeed-search-mode
                                  elfeed-show-mode
                                  eww-mode))

 evil-motion-state-modes (append evil-motion-state-modes
                                 '()))
