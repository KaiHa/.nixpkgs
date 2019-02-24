(require 'notmuch "@notmuch@")

(global-set-key (kbd "C-x n")   'notmuch)

(define-key notmuch-hello-mode-map   (kbd "g") 'notmuch-refresh-this-buffer)
(define-key notmuch-search-mode-map  (kbd "g") 'notmuch-refresh-this-buffer)
(define-key notmuch-show-mode-map    (kbd "g") 'notmuch-refresh-this-buffer)
(define-key notmuch-tree-mode-map    (kbd "g") 'notmuch-refresh-this-buffer)
(define-key notmuch-search-mode-map  (kbd "f") (lambda ()
                                                 "Remove `new` tag and go to next thread."
                                                 (interactive)
                                                 (notmuch-search-tag '("-new"))
                                                 (notmuch-search-next-thread)))
(define-key notmuch-search-mode-map  (kbd "D") (lambda ()
                                                 "Delete thread and go to next thread."
                                                 (interactive)
                                                 (notmuch-search-tag '("+trash"))
                                                 (notmuch-search-next-thread)))


(define-abbrev-table 'notmuch-message-mode-abbrev-table
  '(("mfg"     "Mit freundlichen Grüßen\n\nKai Harries")
    ("regards" "Best regards\n\nKai Harries")
    ("shrug"   "¯\\_(ツ)_/¯")))

(setq
 mail-host-address "x230.kaiha.invalid"
 send-mail-function 'smtpmail-send-it
 smtpmail-smtp-server "smtp.gmail.com"
 smtpmail-smtp-service 25

 message-completion-alist '(("^\\(To\\|CC\\|BCC\\):" . notmuch-address-expand-name)
                            ("^\\(Newsgroups\\|Followup-To\\|Posted-To\\|Gcc\\):" . message-expand-group)
                            ("^\\(Resent-\\)?\\(To\\|B?Cc\\):" . message-expand-name)
                            ("^\\(Reply-To\\|From\\|Mail-Followup-To\\|Mail-Copies-To\\):" . message-expand-name)
                            ("^\\(Disposition-Notification-To\\|Return-Receipt-To\\):" . message-expand-name))
 message-forward-as-mime t
 message-forward-show-mml 'best

 notmuch-hello-sections '(notmuch-hello-insert-header
                          notmuch-hello-insert-saved-searches
                          notmuch-hello-insert-search
                          notmuch-hello-insert-alltags
                          notmuch-hello-insert-footer)

 notmuch-address-selection-function (lambda
                                      (prompt collection initial-input)
                                      (completing-read prompt
                                                       (cons initial-input collection)
                                                       nil t nil
                                                       'notmuch-address-history))

 notmuch-saved-searches '((:name "[i]nbox"    :query "tag:inbox" :key "i")
                          (:name "[u]nread"   :query "tag:unread" :key "u" :count-query "tag:unread and tag:inbox")
                          (:name "[t]odo"     :query "tag:todo" :key "t")
                          (:name "[f]lagged"  :query "tag:flagged" :key "f")
                          (:name "[s]ent"     :query "tag:sent" :key "s")
                          (:name "[d]rafts"   :query "tag:draft" :key "d")
                          (:name "[a]ll mail" :query "*" :key "a")
                          (:name "[n]ote2me"  :query "from:kai.harries@gmail.com to:kai.harries@gmail.com" :key "n"))

 notmuch-tagging-keys '(("a" notmuch-archive-tags "Archive")
                        ("d" ("+trash")       "Delete")
                        ("e" ("+expires")     "Mark as expires")
                        ("f" ("+flagged")     "Mark as flagged")
                        ("m" ("+mute")        "Mute thread")
                        ("r" notmuch-show-mark-read-tags "Mark read (-unread)")
                        ("s" ("-new")         "Mark as seen (-new)")
                        ("S" ("+spam")        "Mark as spam")
                        ("t" ("+todo")        "Mark as todo"))


 notmuch-tag-formats '(("unread")
                       ("flagged"           (notmuch-tag-format-image-data tag (notmuch-tag-star-icon)))
                       ("inbox"      "📥"   (notmuch-apply-face tag '(:foreground "black")))
                       ("signed")
                       ("sent"              (notmuch-apply-face tag '(:weight normal :foreground "dim gray")))
                       ("todo"       "ToDo" (notmuch-apply-face tag '(:weight bold :foreground "white" :background "red")))
                       ("attachment" "📎"   (notmuch-apply-face tag '(:weight bold :foreground "dark goldenrod")))
                       ("mute"       "🔕"   (notmuch-apply-face tag '(:foreground "black")))
                       ("calendar"   "📆"   (notmuch-apply-face tag '(:foreground "black")))
                       ("trash"      "🗑"    (notmuch-apply-face tag '(:foreground "black"))))

 notmuch-search-oldest-first t
 notmuch-show-all-tags-list t
 notmuch-show-logo nil)


(add-hook 'message-send-hook (lambda ()
  (or (message-field-value "Subject")
      (yes-or-no-p "Really send without Subject? ")
      (keyboard-quit))))

(add-hook 'after-init-hook (lambda ()
  (add-hook 'notmuch-before-tag-hook (lambda ()
    (setq tag-changes (append tag-changes '("-new")))))))

(defadvice notmuch-show-view-part (around my-notmuch-show-view-part activate)
  "View the MIME part containing point in emacs but dont delete the other frames."
  (interactive)
  (cl-letf (((symbol-function 'delete-other-windows) #'ignore))
    ad-do-it))

;;;; Faces ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(face-spec-set 'notmuch-crypto-decryption        '((t (:background "purple" :foreground "white"))))
(face-spec-set 'notmuch-crypto-signature-bad     '((t (:background "IndianRed1" :foreground "black"))))
(face-spec-set 'notmuch-crypto-signature-unknown '((t (:background "IndianRed1" :foreground "black"))))
(face-spec-set 'notmuch-search-flagged-face      '((t nil)))
(face-spec-set 'notmuch-tag-added                '((t (:underline "forest green"))))
(face-spec-set 'notmuch-tag-face                 '((t (:foreground "navy blue" :weight normal))))
