(require 'elfeed)

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "heise\\.de"
                              :feed-title "iMonitor"
                              :remove 'unread))

(add-hook 'elfeed-db-update-hook 'elfeed-db-save)

(define-key elfeed-search-mode-map (kbd "SPC") 'scroll-up-command)
(define-key elfeed-search-mode-map (kbd "<backspace>") 'scroll-down-command)


(defface art-elfeed-entry
  '((t :foreground "#f0f"))
  "Marks an Elfeed entry that is tagged as art.")

(defface itsec-elfeed-entry
  '((t :foreground "#00b"))
  "Marks an Elfeed entry that is tagged as itsec.")

(defface noisy-elfeed-entry
  '((t :foreground "#777"))
  "Marks an Elfeed entry that is tagged as noisy.")

(defface riddle-elfeed-entry
  '((t :foreground "#808"))
  "Marks an Elfeed entry that is tagged as riddle.")

(push '(art    art-elfeed-entry)    elfeed-search-face-alist)
(push '(itsec  itsec-elfeed-entry)  elfeed-search-face-alist)
(push '(noisy  noisy-elfeed-entry)  elfeed-search-face-alist)
(push '(riddle riddle-elfeed-entry) elfeed-search-face-alist)

(setq
 elfeed-feeds '("http://www.brendangregg.com/blog/rss.xml"
                "http://draketo.de/rss.xml"
                ("https://fivethirtyeight.com/tag/the-riddler/feed/" riddle)
                ("https://www.heise.de/newsticker/heise-atom.xml" noisy)
		("https://www.heise.de/netze/netzwerk-tools/imonitor-internet-stoerungen/feed/aktuelle-meldungen/" noisy)
                ("https://www.lightbluetouchpaper.org/feed/" itsec)
                "https://lwn.net/headlines/rss"
                "https://mindhacks.com/feed/"
                "https://blog.mozilla.org/feed/"
                "http://nullprogram.com/feed/"
                "http://planet.emacsen.org/atom.xml"
                "https://possiblywrong.wordpress.com/feed/"
		("https://www.schneier.com/blog/atom.xml" itsec)
                ("http://we-make-money-not-art.com/feed/" art))
 elfeed-search-title-max-width 100)

(defadvice elfeed-search-update--force (after my-elfeed-search-update--force activate)
  "Force refresh view of the feed listing (and save db)"
  (interactive)
  (elfeed-db-save))


(defun my-upload-elfeed-db ()
  "Upload the elfeed db into the cloud."
  (interactive)
  (elfeed-db-save)
  (elfeed-db-unload)
  (rclone-sync "~/.elfeed" "gcrypt:elfeed-db.tar.xz"))


(defun my-download-elfeed-db ()
  "Download the elfeed db from the cloud."
  (interactive)
  (elfeed-db-unload)
  (rclone--call "rm" "-rf" (expand-file-name "~/.elfeed.bak"))
  (rclone--call "mv" (expand-file-name "~/.elfeed") (expand-file-name "~/.elfeed.bak"))
  (rclone-sync "gcrypt:elfeed-db.tar.xz" "~/"))
