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
