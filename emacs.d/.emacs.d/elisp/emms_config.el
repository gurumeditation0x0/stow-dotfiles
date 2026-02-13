;;; -----------------------------
;;; EMMS:
;;; Configuration Windows : mplayer
;;; Configuration Linux : mpv
;;; -----------------------------

:: ;; ATTENTION !!!
;;
;;   POUR WINDOWS MPLAYER DOIT ÊTRE DANS LES PATH 
;;
;; Windows invite de commande pour ajouter le chemin vers le binaire windows de mpv
;; setx PATH "%PATH%;C:\Users\%USERPROFILE%\bin"
;;
;; Windows Powershell 
;; [Environment]::SetEnvironmentVariable("Path", $Env:Path;$Env:USERPROFILE\bin", "User")

;; Pour choisir la résolution youtube, uniquement pour Linux
;; echo "ytdl-format=bestvideo[height<=?480][fps<=?30][vcodec!=?vp9]+bestaudio/best" >> /home/niala/.config/mpv/mpv.conf

(require 'emms)
(require 'emms-setup)
(require 'emms-player-simple)

;; Initialisation EMMS
(emms-all)
(emms-default-players)

;; Répertoire musique par défaut
(setq emms-source-file-default-directory "~/musique/")
(emms-add-directory-tree emms-source-file-default-directory)

;; -----------------------------
;; Détection OS + players
;; -----------------------------

(pcase system-type
   ('gnu/linux
   ;; Players Linux
   (setq emms-player-list
         '(emms-player-mpv
           emms-player-vlc
           emms-player-mplayer))

   ;; mpv doit être dans le PATH)
   ;(setq emms-player-mpv-command-name "mpv")
   (setq emms-player-mpv-parameters
         '("--quiet"
           "--ytdl-format=bestvideo[height<=?480][fps<=?30][vcodec!=?vp9]+bestaudio/best")))

   ;; IPC Unix socket (Linux uniquement)
   ;;(setq emms-player-mpv-ipc-server "/tmp/mpv-ipc"))

  ;; -------------------------
  ;; Windows : mplayer uniquement
  ;; -------------------------
  ('windows-nt
   (setq emms-player-list
         '(emms-player-mplayer
           emms-player-mpg321
           emms-player-ogg123))

   ;; ATTENTION pour windows mplayer doit être dans les PATH.
   ;; On enlève la vidéo et les messsages on ne va pas utiliser la vidéo sous Windows.
   (setq emms-player-mplayer-command-name "mplayer")
   (setq emms-player-mplayer-parameters
         '("-really-quiet"
           "-novideo"
           "-slave"
           "-softvol"))

    ;; -------------------------
  ;; fallback minimal
  ;; -------------------------
  (_
   (setq emms-player-list '(emms-player-mplayer))))

;; -----------------------------
;; Volume avec mplayer
;; -----------------------------
;; (defun my-emms-mplayer-volume-change (amount)
;;   "Changer le volume mplayer via EMMS."
;;   (when (process-live-p emms-player-simple-process)
;;     (process-send-string
;;      emms-player-simple-process
;;      (format "volume %d\n" amount))))

;;(setq emms-volume-change-function #'my-emms-mplayer-volume-change)


;; -----------------------------
;; Interface playlist
;; -----------------------------
(setq emms-playlist-buffer-name "*EMMS Playlist*")
(add-hook 'emms-playlist-mode-hook
          (lambda () (setq truncate-lines t)))

;; -----------------------------
;; Messages propres
;; -----------------------------
(setq emms-show-format "♪ %s")
(setq emms-playing-time-display-format "%s")

;; -----------------------------
;; Raccourcis utiles
;; -----------------------------
;; (Dépend des claviers)
(global-set-key (kbd "C-c e p") #'emms-play-playlist)
(global-set-key (kbd "C-c e s") #'emms-stop)
(global-set-key (kbd "C-c e n") #'emms-next)
(global-set-key (kbd "C-c e b") #'emms-previous)
(global-set-key (kbd "C-c e SPC") #'emms-pause)

