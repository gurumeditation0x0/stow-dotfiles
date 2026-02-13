
;;; init.el --- Configuration principale d'Emacs -*- lexical-binding: t; -*-
;;; License: GPLv3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Variables globales et encodage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'gnus)
(require 'message)


(setq org-show-notification-handler 'ignore)
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
(unless (boundp 'my-os)
  (setq my-os
        (cond
         ((eq system-type 'windows-nt) 'windows)
         ((eq system-type 'gnu/linux)  'linux)
         ((eq system-type 'darwin)     'mac)
         (t 'unknown))))
;; Home normal
(setq home-dir
      (cond
       ((eq my-os 'windows) (getenv "USERPROFILE"))
       ((eq my-os 'linux) (getenv "HOME"))
       ((eq my-os 'mac) (getenv "HOME"))
       (t "~")))

(setq default-directory home-dir)
(message "home-dir %s" home-dir)

;; ;; Chemins importants
(setq org-directory (concat home-dir "/org/"))
;;(setq custom-file (concat user-emacs-directory "/emacs-custom.el"))
(setq my-elisp-dir (concat user-emacs-directory "/elisp")) ;; pour tes fichiers elisp
(setq my-config-dir (concat user-emacs-directory "/config")) ;; pour tes fichiers conf
(setq my-dev-dir (concat home-dir "/dev")) ;; pour tes fichiers dev

;; (message "home dir %s" home-dir)
;; (message "emacs directory %s" user-emacs-directory)

;; ;; Ajouter dossier elisp au load-path
(add-to-list 'load-path my-elisp-dir)
(add-to-list 'load-path my-config-dir)
(add-to-list 'load-path my-dev-dir)


;; (setq calendar-latitude 48.584667    ;; latitude
;;       calendar-longitude 7.736424    ;; longitude
;;       calendar-location-name "Strasbourg, FR")


;;(setq org-clock-sound "~/dev/Cloches/7s.wav")

;; (add-to-list 'Info-directory-list "~/.info")
;; (add-to-list 'Info-directory-list "~/.local/share/info")


;; (set-language-environment "French")
;; (prefer-coding-system 'utf-8)
;; (setq default-buffer-file-coding-system 'utf-8
;;       coding-system-for-write 'utf-8
;;       buffer-file-coding-system 'utf-8
;;       save-buffer-coding-system 'utf-8-unix
;;       require-final-newline t)

;; (setq custom-file "~/.emacs.d/emacs-custom.el")
;; (setq frame-title-format (list "@" system-name " : %b (%f)"))
;; (setq inhibit-startup-screen t)

;; (delete-selection-mode 1)
;; (global-auto-revert-mode 1)
;; (setq debug-on-error nil
;;       mouse-autoselect-window t
;;       vc-follow-symlinks t
;;       bookmark-save-flag 1
;;       register-preview-delay 0.8
;;       register-preview-function #'consult-register-format
;;       compilation-scroll-output t
;;       mouse-yank-at-point t)

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
;; 	("nongnu" . "https://elpa.nongnu.org/nongnu/")))
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

;; JourNuit : changement automatique de thème jour/nuit
;; (use-package JourNuit
;;   :ensure nil
;;   :load-path "~/dev/JourNuit/JourNuit-0.el"
;;   :config
;;   (setq JourNuit-light-theme 'modus-operandi-tinted
;;         JourNuit-dark-theme  'ef-elea-dark)
;;   (JourNuit))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gestion des fenêtres. workgroups, dashboard. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Dashboard / fenêtres
;(load "dashboard-perso.el")

;; (use-package workgroups
;;   :config
;;   (setq wg-session-file
;;         (concat user-emacs-directory "/emacs_desktops")
;;         wg-restore-position t)
;;   (defun charge-wg_default_start ()
;;     (wg-load (concat user-emacs-directory "/emacs_desktops")))
;;   (run-at-time "2 sec" nil #'charge-wg_default_start))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dired — gestion des fichiers et navigation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ----------------------------------------------------------------
;; Paramètres d'affichage
;; ----------------------------------------------------------------
;; - dired-omit-files : cacher les fichiers temporaires ou cachés
;; - dired-listing-switches : format d'affichage des fichiers
;; - dired-kill-when-opening-new-dired-buffer : remplacer le buffer courant
;; - dired-dwim-target : devine automatiquement le répertoire cible

(setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$"
      dired-listing-switches "-aBhl --group-directories-first"
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

;; corfu : completion inline
(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 3)
  (completion-styles '(basic))
  :init
  (global-corfu-mode))

;; cape : completion supplémentaire pour corfu
(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

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
;; Org-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Paramètres visuels et fontification
(custom-set-variables '(org-fontify-quote-and-verse-blocks t))
(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :family "Ubuntu" :height 1.6))))
 '(org-level-2 ((t (:inherit outline-1 :family "Ubuntu" :height 1.4))))
 '(org-level-3 ((t (:inherit outline-3 :family "Ubuntu" :height 1.2))))
 '(org-level-4 ((t (:inherit outline-4 :family "Ubuntu" :height 1.1))))
 '(org-level-5 ((t (:inherit outline-5 :family "Ubuntu" :height 1.1)))))

(setq org-hide-emphasis-markers nil
      org-descriptive-links t
      org-hide-leading-stars nil
      org-fontify-quote-and-verse-blocks t
      org-directory "~/org/"
      ;; org-agenda-files (list "~/org/todo.org")
      org-todo-keywords '((sequence "A FAIRE" "EN COURS" "|" "FAIT" "ABANDONNÉ"))
      org-todo-keyword-faces '(("TODO" . org-warning)
                               ("EN COURS" . "yellow")
                               ("ABANDONNÉ" . "blue")))

;; Son d'alarme de org-timer-set-timer
(setq org-clock-sound "~/dev/Cloches/cloche7s.wav")

;; org-capture templates
(add-hook 'org-capture-after-finalize-hook 'my-org-capture-hook)
(setq org-capture-templates
      `(("p" "Protocol" entry
         (file+headline ,(concat org-directory "notes.org") "Inbox")
         "* [[%:link][%:description]] \n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n%?")
        ("L" "Protocol Link" entry
         (file+headline ,(concat org-directory "notes.org") "Inbox")
         "* [[%:link][%:description]] \n%?")
        ("o" "Link capture" entry
         (file+headline ,(concat org-directory "notes.org") "Inbox")
         "* %a %U")))

;; org-appear : afficher les emphases seulement à l'édition
(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-startup-folded t))

(use-package org-transclusion
  :ensure t)
(require 'org-protocol)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Magit / Git
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Modules externes selon l'OS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(when (eq system-type 'gnu/linux)
(load "emms_config.el")
  ;; Shell
(load "eshell_conf.el")

;; EMMS


;; Elfeed
;; (load "~/.emacs.d/config/elfeed.el")

;; Météo biome
(load "meteo.el")


;; Fonctions perso
;; (load "~/.emacs.d/elisp/mes_fonctions.el") 

;; Treemacs
;;(load "treemacs.el")

;;;; Dashboard / fenêtres
(load-file "~/.emacs.d/elisp/dashboard-perso.el")

;; Org Novelist
;;(load-file (concat my-dev-dir "/"))

;;(load-file (concat my-dev-dir "/JourNuit/JourNuit-0e.el"))
(load-file (concat my-dev-dir "/JourNuit/JourNuit-0e.el"))

;; Gnu Mails
(load-file (concat my-dev-dir "/Gnus/gnus-conf.el"))

;;)

;; ;; Si on est sous Linux on peut charger mu4e 
;; (when (eq system-type 'gnu/linux)
;; ;; Email
;; (load "~/.emacs.d/config/email.el"))
