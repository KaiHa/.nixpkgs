(require 'elfeed)

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "lightbluetouchpaper\\.org"
                              :add '(itsec)))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "schneier\\.com"
                              :add '(itsec)))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "heise\\.de"
                              :add '(noisy)))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "fivethirtyeight\\.com"
                              :feed-title "The Riddler"
                              :add '(riddle)))

(add-hook 'elfeed-db-update-hook 'elfeed-db-save)


(defface itsec-elfeed-entry
  '((t :foreground "#00b"))
  "Marks an Elfeed entry that is tagged as itsec.")

(defface noisy-elfeed-entry
  '((t :foreground "#777"))
  "Marks an Elfeed entry that is tagged as noisy.")

(defface riddle-elfeed-entry
  '((t :foreground "#a0a"))
  "Marks an Elfeed entry that is tagged as riddle.")

(push '(itsec itsec-elfeed-entry)   elfeed-search-face-alist)
(push '(noisy noisy-elfeed-entry)   elfeed-search-face-alist)
(push '(riddle riddle-elfeed-entry) elfeed-search-face-alist)

(setq
 elfeed-feeds '("http://www.brendangregg.com/blog/rss.xml"
                "https://fivethirtyeight.com/tag/the-riddler/feed/"
                "https://www.heise.de/newsticker/heise-atom.xml"
		"https://www.heise.de/netze/netzwerk-tools/imonitor-internet-stoerungen/feed/aktuelle-meldungen/"
                "https://www.lightbluetouchpaper.org/feed/"
                "https://mindhacks.com/feed/"
                "https://blog.mozilla.org/feed/"
                "http://nullprogram.com/feed/"
                "http://planet.emacsen.org/atom.xml"
                "https://possiblywrong.wordpress.com/feed/"
		"https://www.schneier.com/blog/atom.xml"
                "http://we-make-money-not-art.com/feed/")
 elfeed-search-title-max-width 100)

(define-key elfeed-search-mode-map (kbd "j") 'next-line)
(define-key elfeed-search-mode-map (kbd "k") 'previous-line)

(defadvice elfeed-search-update--force (after my-elfeed-search-update--force activate)
  "Force refresh view of the feed listing (and save db)"
  (interactive)
  (elfeed-db-save))


(defun my-elfeed-upload-db ()
  "Upload the elfeed db into the cloud."
  (interactive)
  (elfeed-db-save)
  (elfeed-db-unload)
  (rclone-sync "~/.elfeed" "gcrypt:elfeed-db.tar.xz"))


(defun my-elfeed-download-db ()
  "Download the elfeed db from the cloud."
  (interactive)
  (elfeed-db-unload)
  (shell-command "rm -rf ~/.elfeed.bak")
  (shell-command "mv ~/.elfeed ~/.elfeed.bak")
  (rclone-sync "gcrypt:elfeed-db.tar.xz" "~/"))
