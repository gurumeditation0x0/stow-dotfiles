
;; elfeed.el

(use-package elfeed
  :ensure t
  :config
  (setq elfeed-db-directory "~/.emacs.d/elfeed/elfeed_db")
  (setq elfeed-enclosure-default-dir (expand-file-name "~/Téléchargements"))
  (setq elfeed-tube-captions-languages '("fr" "en" "english (auto generated)"))
  :bind
  (:map elfeed-search-mode-map
        ("U" . elfeed-update)
        ("a" . elfeed-ajout-tag-alire)))

(use-package elfeed-org
  :config
  (setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed/elfeed.org"))
  (elfeed-org))


(defun elfeed-ajout-tag-alire ()
  "Add the 'ALIRE' tag to all selected entries."
  (interactive)
  (when (eq major-mode 'elfeed-search-mode)
    (let* ((entries (elfeed-search-selected))
           (tag 'ALIRE))
      (dolist (entry entries)
        (elfeed-tag entry tag))
      (message "Added 'ALIRE' tag to selected entries.")
      (dolist (entry entries)
        (elfeed-search-update-entry entry)))))


;; (setq elfeed-search-filter "@9-months-ago +unread"))

;; (use-package elfeed-goodies
;;   :config
;;   (setq elfeed-goodies/entry-pane-position 'bottom))
;; (elfeed-goodies/setup)

;; (use-package elfeed-dashboard
;;   :ensure t
;;   :config
;;   (setq elfeed-dashboard-file "~/.emacs.d/elfeed/elfeed-dashboard.org")
;;   ;; update feed counts on elfeed-quit
;;   (advice-add 'elfeed-search-quit-window :after #'elfeed-dashboard-update-links))


(use-package elfeed-tube
  :ensure t
  :after elfeed
  :demand t
  :config
  (setq elfeed-tube-auto-save-p t) ; default value
  (setq elfeed-tube-auto-fetch-p t)  ; default value
  (elfeed-tube-setup)

  :bind (:map elfeed-show-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)
         :map elfeed-search-mode-map
         ("F" . elfeed-tube-fetch)
         ([remap save-buffer] . elfeed-tube-save)))

(use-package elfeed-tube-mpv
  :ensure t ;; or :straight t
  :bind (:map elfeed-show-mode-map
              ("C-c C-f" . elfeed-tube-mpv-follow-mode)
              ("C-c C-w" . elfeed-tube-mpv-where)))

(defun my/get-youtube-url (link)
  (let ((watch-id (cadr
                   (assoc "watch?v"
                          (url-parse-query-string
                           (substring
                            (url-filename
                             (url-generic-parse-url link))
                            1))))))
    (concat "https://www.youtube.com/watch?v=" watch-id)))

;; (define-emms-source elfeed (entry)
;;     (let ((track (emms-track
;;                   'url (my/get-youtube-url (elfeed-entry-link entry)))))
;;       (emms-track-set track 'info-title (elfeed-entry-title entry))
;;       (emms-playlist-insert-track track)))
 
(defun elfeed-add-emms-youtube ()
  (interactive)
  (emms-add-elfeed elfeed-show-entry)
  (elfeed-tag elfeed-show-entry 'watched)
  (elfeed-show-refresh))

;; Mark all YouTube entries
;; (add-hook 'elfeed-new-entry-hook
;;           (elfeed-make-tagger :feed-url "youtube\\.com"
;;                               :add '(vidéo yt)))

;; (elfeed-make-tagger :feed-url "youtube\\.com"
;;                               :add '(vidéo yt))


(defun elfeed-mark-all-as-read ()
  "Mark currently shown articles read"
  (interactive)
  (mark-whole-buffer)
  (elfeed-search-untag-all-unread)
  (define-key elfeed-search-mode-map (kbd "R") 'elfeed-mark-all-as-read)) 
 
(defun my/elfeed-search-quit-and-kill-buffers ()
  "Save the database, then kill elfeed buffers, asking the user
for confirmation when needed."
  (interactive)
  (elfeed-db-save)
  (let (buf)
    (dolist (file rmh-elfeed-org-files)
      (setq buf (get-file-buffer file))
      (when (and (buffer-modified-p buf)
             file
             (y-or-n-p (format "Save file %s? " file)))
        (with-current-buffer buf (save-buffer)))
      (kill-buffer buf)))
  (kill-buffer "*elfeed-log*")
  (kill-buffer (current-buffer)))
