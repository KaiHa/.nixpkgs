(require 'elfeed)

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "heise\\.de"
                              :feed-title "iMonitor"
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "heise\\.de"
                              :entry-title "heise\\+ |"
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "heise\\.de"
                              :entry-title "heise-Angebot:"
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "heise\\.de"
                              :entry-title "Anzeige:"
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "heise\\.de"
                              :entry-title "TechStage |"
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "lwn\\.net"
                              :entry-title "Security updates for"
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "lwn\\.net"
                              :entry-title "LWN.net Weekly Edition for"
                              :remove 'unread))

(add-hook 'elfeed-new-entry-hook
          (elfeed-make-tagger :feed-url "schneier\\.com"
                              :entry-title "Friday Squid Blogging"
                              :remove 'unread))

(add-hook 'elfeed-db-update-hook 'elfeed-db-save)

(define-key elfeed-search-mode-map (kbd "SPC") 'scroll-up-command)
(define-key elfeed-search-mode-map (kbd "<backspace>") 'scroll-down-command)
(define-key elfeed-search-mode-map (kbd "<") 'beginning-of-buffer)
(define-key elfeed-search-mode-map (kbd ">") 'end-of-buffer)
(define-key elfeed-search-mode-map (kbd "o") 'elfeed-toggle-sort)
(define-key elfeed-show-mode-map   (kbd "n")   'next-line)
(define-key elfeed-show-mode-map   (kbd "p")   'previous-line)
(define-key elfeed-show-mode-map   (kbd "M-n") 'elfeed-show-next)
(define-key elfeed-show-mode-map   (kbd "M-p") 'elfeed-show-prev)

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
                ("https://blog.cryptographyengineering.com/atom.xml" itsec)
                "http://draketo.de/rss.xml"
                ("https://fivethirtyeight.com/tag/the-riddler/feed/" riddle)
                ("https://www.heise.de/newsticker/heise-atom.xml" noisy)
		("https://www.heise.de/netze/netzwerk-tools/imonitor-internet-stoerungen/feed/aktuelle-meldungen/" noisy)
                ("https://www.lightbluetouchpaper.org/feed/" itsec)
                ("https://lwn.net/headlines/rss" lwn)
                ("https://microkerneldude.wordpress.com/feed/" embedded)
                "https://mindhacks.com/feed/"
                "https://blog.mozilla.org/feed/"
                "http://nullprogram.com/feed/"
                "https://possiblywrong.wordpress.com/feed/"
		("https://www.schneier.com/blog/atom.xml" itsec)
                ("http://we-make-money-not-art.com/feed/" art)
                ("https://haskellweekly.news/haskell-weekly.atom" haskell)
                ("https://haskellweekly.news/podcast/feed.rss" audio haskell)
                ("http://feeds.soundcloud.com/users/soundcloud:users:159515815/sounds.rss" audio hildesheim)
                ("https://www.hildesheim.de/magazin/rss.php" hildesheim)
                ("https://freizeit.hildesheimer-allgemeine.de/veranstaltungskalender/feed/" hildesheim)
                ("http://nordstadt-mehr-wert.de/feed" hildesheim)
                "http://bit-player.org/feed"
                "https://danluu.com/atom.xml"
                "http://dvdp.tumblr.com/rss"
                "https://www.econlib.org/feed/indexCaplan_xml"
                ("http://feeds.gimletmedia.com/eltshow" audio)
                "https://feeds.feedburner.com/Pidjin"
                "https://feeds.feedburner.com/MrMoneyMustache"
                "http://www.overcomingbias.com/feed"
                "https://piecomic.tumblr.com/rss"
                ("https://www.npr.org/rss/podcast.php?id=510289" audio)
                "https://blog.plover.com/index.atom"
                ("https://feeds.megaphone.fm/stuffyoushouldknow" audio)
                "https://xkcd.com/atom.xml")
 elfeed-search-title-max-width 80)

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

(defun elfeed-toggle-sort ()
  "Toggle the sort order of the elfeed search."
  (interactive)
  (if (equal elfeed-sort-order 'ascending)
      (setq elfeed-sort-order 'descending)
    (setq elfeed-sort-order 'ascending))
  (elfeed-search-update--force))
