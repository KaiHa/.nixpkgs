(require 'modalka)

(setq-default cursor-type 'bar
              blink-cursor-alist '((bar . box)
                                   (box . bar))
              blink-cursor-blinks 0)
(setq modalka-cursor-type 'hollow)

(global-set-key (kbd "M-ESC") #'modalka-mode)


(defun my-modalka-define (actual-prefix target-prefix)
  "Add a prefix keymap"
  (if (> (length actual-prefix) 0)
      (modalka-remove-kbd (substring actual-prefix 0 -1)))
  (seq-do
   (lambda (key)
     (modalka-define-kbd (concat actual-prefix key)
                         (concat target-prefix key)))
   (append
    (seq-map (lambda (x) (make-string 1 x))
             (number-sequence 33 126 1)) ; Keys '!' to '~'
    '("SPC"))))


;;; Commands without prefix
(my-modalka-define ""   "C-")
(my-modalka-define "g " "M-")
(my-modalka-define "G " "C-M-")

;;; Commands with prefix
(my-modalka-define "c "        "C-c C-")
(my-modalka-define "c SPC "    "C-c ")
(my-modalka-define "c SPC @ "  "C-c @ C-")
(my-modalka-define "c @ "      "C-c @ C-")
(my-modalka-define "x "        "C-x C-")
(my-modalka-define "x SPC "    "C-x ")
(my-modalka-define "x SPC r "  "C-x r ")
