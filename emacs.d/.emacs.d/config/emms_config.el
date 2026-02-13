(use-package emms
  :ensure t
  :init
  ;; Répertoire musique par défaut
  (setq emms-source-file-default-directory
        (expand-file-name "~/musique/"))

  ;; Affichage propre
  (setq emms-show-notifications nil
        emms-playlist-buffer-name "*EMMS Playlist*"
        emms-show-format "♪ %s"
        emms-playing-time-display-format "%s")

  :config
  (require 'emms-setup)
  (require 'emms-player-simple)

  ;; Initialisation complète
  (emms-all)
  (emms-default-players)

  ;; Ajouter la musique
  (when (file-directory-p emms-source-file-default-directory)
    (emms-add-directory-tree emms-source-file-default-directory))

  ;; -----------------------------
  ;; Détection OS
  ;; -----------------------------
  (pcase system-type

    ;; Linux
    ('gnu/linux
     (setq emms-player-list
           '(emms-player-mpv
             emms-player-vlc
             emms-player-mplayer))

    ;; Windows
    ('windows-nt
     (setq emms-player-list
           '(emms-player-mplayer
             emms-player-mpg321
             emms-player-ogg123))

     (setq emms-player-mplayer-command-name "mplayer"))

    ;; ---------- FALLBACK ----------
    (_
     (setq emms-player-list '(emms-player-mplayer))))

  ;; Playlist buffer sans retour ligne
  (add-hook 'emms-playlist-mode-hook
            (lambda () (setq truncate-lines t)))

  ;; Raccourcis
  (global-set-key (kbd "C-c e p") #'emms-play-playlist)
  (global-set-key (kbd "C-c e s") #'emms-stop)
  (global-set-key (kbd "C-c e n") #'emms-next)
  (global-set-key (kbd "C-c e b") #'emms-previous)
  (global-set-key (kbd "C-c e SPC") #'emms-pause))

;;(when (eq system-type 'gnu/linux)
;; (use-package ivy-youtube-key
;;   :if (eq system-type 'gnu/linux)
;;     :ensure t
;;     :init
;;     (setq ivy-youtube-key 'AIzaSyDVVxgm2W1B7yydnJGe5N_y4dHVFJJoFag)
;;     :config
;;     ;;  (setq ivy-youtube-play-at "/home/alain/.guix-profile/bin/mpv")
;;     (setq ivy-youtube-play-at "/usr/bin/mpv"))
