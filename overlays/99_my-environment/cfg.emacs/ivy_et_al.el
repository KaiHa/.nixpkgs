(historian-mode)
(ivy-historian-mode)
(ivy-mode)
(ivy-rich-mode)

(setq
 ivy-count-format "(%d/%d) "
 ivy-rich-path-style 'abbrev
 ivy-sort-matches-functions-alist '((t . ivy--prefix-sort)
				    (ivy-switch-buffer . ivy-sort-function-buffer))
 ivy-use-virtual-buffers t)
