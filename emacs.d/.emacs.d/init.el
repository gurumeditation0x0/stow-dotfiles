;;; Init.el --- Configuration principale d'Emacs -*- lexical-binding: t; -*-
;;; License: GPLv3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variables globales et encodage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'gnus)
(require 'message)
(require 'org)

(require 'use-package)
(setq use-package-always-ensure t)
(setq alert-default-style 'message)

;; --------------------------------------------------
;; Ne PAS ouvrir les pièces jointes (PDF, etc.)
;; quand on écrit un mail (openwith)
;; --------------------------------------------------
;; (add-hook 'message-mode-hook
;;           (lambda ()
;;             (remove-hook 'find-file-hook #'openwith-file-handler t)))
;;; init.el --- Configuration principale
;; Sécurité : définir my-os si absent
;; (unless (boundp 'my-os)
;;   (setq my-os
;; 	(cond
;; 	 ((eq system-type 'windows-nt) 'windows)
;; 	 ((eq system-type 'gnu/linux)  'linux)
;; 	 ((eq system-type 'darwin)     'mac)
;; 	 (t 'unknown))))
;; ;; Home normal
;; (setq home-dir
;;       (cond
;;        ((eq my-os 'windows) (getenv "USERPROFILE"))
;;        ((eq my-os 'linux) (getenv "HOME"))
;;        ((eq my-os 'mac) (getenv "HOME"))
;;        (t "~")))

;; (setq default-directory home-dir)

;; ;; ;; Chemins importants
;; (setq org-directory (concat home-dir "/org/"))
;; (setq my-elisp-dir (concat user-emacs-directory "/elisp")) ;; pour tes fichiers elisp
;; (setq my-config-dir (concat user-emacs-directory "/config")) ;; pour tes fichiers conf
;; (setq my-dev-dir (concat home-dir "/dev")) ;; pour tes fichiers dev

;; ;; ;; Ajouter dossier elisp au load-path
;; (add-to-list 'load-path my-elisp-dir)
;; (add-to-list 'load-path my-config-dir)
;; (add-to-list 'load-path my-dev-dir)
(set-fontset-font t 'emoji
		  (cond
		   ((eq system-type 'gnu/linux)
		    "Noto Color Emoji")
		   ((eq system-type 'windows-nt)
		    "Segoe UI Emoji"))
		  nil 'prepend)

;; (global-visual-line-mode t)
(abbrev-mode 1)
(recentf-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'package)
;; (setq package-archives
;;       '(("melpa" . "https://melpa.org/packages/")
;;         ("gnu"   . "https://elpa.gnu.org/packages/")
;;	("nongnu" . "https://elpa.nongnu.org/nongnu/")))
;; (package-initialize)

;; ;; use-package natif depuis Emacs 30+
;; (require 'use-package)
;; (setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Debugging tools
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; bug-hunter : analyse les erreurs dans les fichiers init
(use-package bug-hunter)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Association de fichiers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package openwith
  :config
  (setq openwith-associations
	(list
	 (list (openwith-make-extension-regexp
		'("mpg" "mpeg" "mp3" "mp4"
		  "avi" "wmv" "wav" "mov" "flv"
		  "ogm" "ogg" "mkv"))
	       "mpv"
	       '(file))
	 ;; (list (openwith-make-extension-regexp
	 ;;        '("xbm" "pbm" "pgm" "ppm" "pnm"
	 ;;          "png" "gif" "bmp" "tif" "jpeg" "jpg"))
	 ;;       "geeqie"
	 ;;       '(file))
	 (list (openwith-make-extension-regexp
		'("doc" "xls" "ppt" "odt" "ods" "odg" "odp"))
	       "libreoffice"
	       '(file))
	 '("\\.lyx" "lyx" (file))
	 '("\\.chm" "kchmviewer" (file))
	 (list (openwith-make-extension-regexp
		'("pdf" "ps" "ps.gz" "dvi"))
	       "evince"
	       '(file))
	 ))
  (add-to-list  'mm-inhibit-file-name-handlers 'openwith-file-handler)
  (openwith-mode 1))

;; (with-eval-after-load 'openwith
;;   (defun my-openwith-disable-in-message (orig-fun &rest args)
;;     "Empêcher openwith d'ouvrir les fichiers dans les mails."
;;     (unless (derived-mode-p 'message-mode)
;;       (apply orig-fun args)))

;;   (advice-add 'openwith-file-handler
;;               :around #'my-openwith-disable-in-message))

;; (require 'cl-lib)

;; (defun my-message-disable-file-name-handlers ()
;;   (setq-local file-name-handler-alist
;;               (cl-remove-if
;;                (lambda (handler)
;;                  (eq (cdr handler) 'openwith-file-handler))
;;                file-name-handler-alist)))

;; (add-hook 'message-mode-hook #'my-message-disable-file-name-handlers)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Arbres syntaxiques (treesitter)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; treesit-explorer permet de visualiser les nœuds syntaxiques
(setq treesit--explorer-highlight-overlay t)
(setq treesit-explore-mode-hook t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Visibilité et navigation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lin : met en surbrillance la ligne courante
(use-package lin
  :config
  (setq lin-face "lin-green")
  (setq lin-mode-hooks
	'(emms-playlist-mode-hook emms-browser-mode-hook
	  biome-grid-mode-hook bongo-mode-hook dired-mode-hook
	  elfeed-search-mode-hook git-rebase-mode-hook grep-mode-hook
	  ibuffer-mode-hook ilist-mode-hook ledger-report-mode-hook
	  log-view-mode-hook magit-log-mode-hook mu4e-headers-mode-hook
	  notmuch-search-mode-hook notmuch-tree-mode-hook
	  occur-mode-hook org-agenda-mode-hook pdf-outline-buffer-mode-hook
	  proced-mode-hook tabulated-list-mode-hook gnus-mode-hook))
  (lin-global-mode 1))

;; beacon : indique la position du curseur lors du scrolling
(use-package beacon
  :config
  (setq beacon-color "chartreuse")
  (beacon-mode 1))

;; ef-themes : thèmes prédéfinis clairs/foncés
(use-package ef-themes
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :config
  (setq ef-themes-to-toggle '(ef-elea-light ef-autumn)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Undo et édition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; undo-tree : historique des undo/redo visuel
(use-package undo-tree
  :config
  (setq undo-tree-visualizer-timestamps t
	undo-tree-visualizer-diff t)
  (global-undo-tree-mode t))
;; multiple-cursors : édition multiple
(use-package multiple-cursors)
;; smartparens : gestion avancée des paires
(use-package smartparens
  :hook (prog-mode text-mode markdown-mode)
  :config
  (require 'smartparens-config))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Icônes et interface
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; all-the-icons : icônes dans dired et elsewhere
(use-package all-the-icons
  :config
  (setq all-the-icons-dired-monochrome nil))

;; all-the-icons-dired : icônes dans dired
(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

;;--------------------------------------------------
;; Gestion des sauvegardes automatiques
;;--------------------------------------------------

;; Créer le dossier de backups
(make-directory "~/.emacs.d/backups/" t)

;; Rediriger tous les ~ vers ce dossier
(setq backup-directory-alist
      '(("." . "~/.emacs.d/backups/")))

;; Auto-saves aussi dans ~/.emacs.d/backups/
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs.d/backups/" t)))

;; Options pour les auto-saves
(setq auto-save-interval 100
      auto-save-timeout 900)

;; Options recommandées
(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 10
      kept-old-versions 5
      version-control t)
(setq dired-omit-files "^\\.[^.]|^#|#$|~$"
      dired-listing-switches "-alh --group-directories-first"
      dired-kill-when-opening-new-dired-buffer t
      dired-dwim-target t)

;; On utilise M-x dired-omit-mode pour activer/désactiver l'affichage
(eval-after-load 'dired
		 '(define-key dired-mode-map (kbd "C-c .") 'dired-omit-mode))

;; ----------------------------------------------------------------
;; Fonction pour envoyer un fichier depuis dired à mon téléphone via KDEConnect
;; ----------------------------------------------------------------
(setq montel "RMX3085") ;; nom du téléphone
(defun kdeconnect ()
  "Envoie le fichier sélectionné de dired à mon téléphone RMX3085 via KDEConnect."
  (interactive)
  (dired-shell-command
   (format "kdeconnect-cli -n %s --share \"%s\""
	   montel
	   (dired-get-file-for-visit))))
 (eval-after-load 'dired
  '(define-key dired-mode-map (kbd "s-k") 'kdeconnect))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion et minibuffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ido : navigation rapide de fichiers et buffers
(use-package ido
  :config
  (ido-mode 1)
  (global-set-key (kbd "C-x C-f") 'ido-find-file)
  (global-set-key (kbd "C-x b") 'view-buffer)
		    (global-set-key (kbd "C-x C-b") 'list-buffers))

;; vertico : completion améliorée
(use-package vertico
  :init
  (vertico-mode))

;; orderless : style de completion flexible
(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))

;; marginalia : annotations dans minibuffer
(use-package marginalia
  :init
  (marginalia-mode 1))

;; embark / embark-consult : actions contextuelles
(use-package embark)
(use-package embark-consult)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit / Git
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(when (eq system-type 'gnu/linux)

;; Corfu
(load "config-corfu.el")

;; Org-Mode
(load "config-org.el")
;; Calendrier (calfw + org-gcal)
(load "config-calendrier.el")
;; Org-Babel
(load "config-org-babel.el")

;; Python
;; (load "config-python.el")

;; Eshell
(load "config-eshell.el")

;; EMMS
 (load "config-emms.el")

;; Météo biome
(load "config-biome.el")

;; Treemacs
(load "config-treemacs.el")

;; Dashboard
(load "config-dashboard.el")

;; JourNuit
(load "jour-nuit.el")
(journuit-apply-and-schedule)

;; Gnu Mails
(load "config-gnus.el")

;; Org-Novelist
(load "org-novelist.el")

;; Yasnippets
(load "config-yasnippets.el")

;; Denote
(load "config-denote.el")

;; Perspective
(load "config-persp.el")
;;
;; Elfeed
;; (load "~/.emacs.d/config/config-elfeed.el")

;; Julia language + lsp
;; (load "config-julia.el")

;; Maxima + Octave
;;(load "config-octave.el")

;; Gustave-mode
;;(load "gus-07.el")

;; Fonctions perso
;; (load "~/.emacs.d/elisp/mes_fonctions.el")
(message " 🖥️ Operating System my-os %s" my-os)
(message " 🐧 my-windows-username = %s" my-windows-username)
(message " 🐧 Nom Utilisateurs Emacs = %s" user-login-name)
(message " 📁 Répertoire home-dir %s" home-dir)
(message " 📁 Répertoire user-emacs-directory %s" user-emacs-directory)

(message " 📁 Répertoire = %s" my-denote-directory)

;; (use-package workgroups
;; ;;  :ensure t
;; ;;  :defer t
;;   :init
;;   (defvar wg-session-file
;;     (expand-file-name "wgwindows/wg_default_start" user-emacs-directory)
;;     "Fichier de session pour workgroups.")
;;   :config
;; ;;  (unless (file-exists-p (file-name-directory wg-session-file))
;; ;;    (make-directory (file-name-directory wg-session-file) t))
;;   ;; bindings simples (appeler manuellement sauvegarde/chargement)
;;   (global-set-key (kbd "C-c w c") 'wg-create-workgroup)
;;   (global-set-key (kbd "C-c w s") 'wg-save)
;;   (global-set-key (kbd "C-c w o") 'wg-load)
;;   (global-set-key (kbd "C-c w l") 'wg-list-workgroups)
;;   (global-set-key (kbd "C-c w n") 'wg-switch-workgroup))

;; ;; Charger une session workgroups spécifique au démarrage (sans sauvegarde automatique)
;; (setq wg-session-file
;;       (concat user-emacs-directory "/wgwindows/wg_default_start")
;;       wg-restore-position t)

;; (defun charge-wg_default_start ()
;;   (let ((f (concat user-emacs-directory "/wgwindows/wg_default_start")))
;;     (when (and (fboundp 'wg-load) (file-exists-p f))
;;       (condition-case err
;; 	  (wg-load f)
;; 	(error (message "Échec chargement session workgroups : %s" err))))))
;;    (run-at-time "2 sec" nil #'charge-wg_default_start)
;; ;;(add-hook 'emacs-startup-hook #'charge-wg_default_start)

;; (use-package workgroups2
;;   :ensure t
;;   :defer t
;;   :init
;;   (defvar wg-session-file
;;     (expand-file-name "workgroups/last-session.wg" user-emacs-directory)
;;     "Fichier de session workgroups2.")
;;   :config
;;   (unless (file-exists-p (file-name-directory wg-session-file))
;;     (make-directory (file-name-directory wg-session-file) t))
;;   ;; bindings simples
;;   (global-set-key (kbd "C-c w c") 'wg-create)
;;   (global-set-key (kbd "C-c w s") 'wg-save-session)  ;; appeler manuellement
;;   (global-set-key (kbd "C-c w o") 'wg-load-session)  ;; appeler manuellement
;;   (global-set-key (kbd "C-c w l") 'wg-list)
;;   (global-set-key (kbd "C-c w n") 'wg-switch-to)

;; ;; Si on est sous Linux on peut charger mu4e
;; (when (eq system-type 'gnu/linux)
;; ;; Email
;; (load "~/.emacs.d/config/email.el"))
;; ;; Assure que ispell est chargé avant de configurer Hunspell
;; (with-eval-after-load 'ispell
;;   ;; chemin vers Hunspell.exe
;;   (setq ispell-program-name "C:/Users/david/GNU/hunspell/bin/hunspell.exe")

;;   ;; dictionnaires Hunspell
;;   (setq ispell-local-dictionary-alist
;;         '(("fr_FR"
;;            "[A-Za-zÀ-ÖØ-öø-ÿ'-]"   ;; caractères valides
;;            "C:/Users/david/GNU/hunspell/share/hunspell/fr_FR/fr.aff"
;;            "C:/Users/david/GNU/hunspell/share/hunspell/fr_FR/fr.dic"
;;            nil
;;            ("ISO8859-1"))))

;;   ;; Hunspell moderne
;;   (setq ispell-really-hunspell t))
