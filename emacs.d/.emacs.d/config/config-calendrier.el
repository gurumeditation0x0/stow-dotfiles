;;; config-calendrier.el --- Configuration pour les calendriers (calfw + org-gcal) -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration unifiée pour la gestion des calendriers dans Emacs.
;; Ce fichier regroupe :
;; - calfw : Framework pour l'affichage des calendriers (vue mensuelle, hebdomadaire, etc.)
;; - org-gcal : Synchronisation entre Org et Google Calendar
;;
;; Basé sur :
;; - https://github.com/kiwanami/emacs-calfw (calfw)
;; - https://github.com/emacsmirror/org-gcal (org-gcal)

;;; Code:

;; =============================================================================
;; 1. Configuration de calfw (Calendar Framework)
;; =============================================================================

(use-package calfw
  :ensure t
  :after org
  :config
  ;; Charger les modules nécessaires pour calfw (si disponibles)
  (when (require 'calfw nil t)
    (when (require 'calfw-cal nil t)
      (message "calfw-cal chargé"))
    (when (require 'calfw-org nil t)
      (message "calfw-org chargé"))
    
    ;; Configuration de base pour calfw
    (setq calfw-use-calfw-calendar t)  ;; Utiliser calfw comme calendrier principal
    
    ;; Personnalisation des couleurs et apparences
    (set-face-attribute 'calfw-today-face nil :background "#fad163" :weight 'bold)
    (set-face-attribute 'calfw-sunday-face nil :foreground "red" :weight 'bold)
    (set-face-attribute 'calfw-saturday-face nil :foreground "blue" :weight 'bold)
    (set-face-attribute 'calfw-holiday-face nil :background "#ffd5e5" :foreground "purple")
    
    ;; Format des événements dans le calendrier
    (setq calfw-event-format-overview "%t")  ;; Titre seulement dans la vue mensuelle
    (setq calfw-event-format-days-overview "%s %t")  ;; Heure + titre dans la vue hebdomadaire
    (setq calfw-event-format-detail "%s %e-%E %t\n%l\n%d")  ;; Détails complets dans la vue quotidienne
    
    ;; Configuration des sources de données pour calfw
    ;; Org et Diary sont ajoutés comme sources par défaut
    (setq calfw-sources
          '((calfw-org-source :name "Org Agenda" :color "dark blue")
            (calfw-cal-source :name "Diary" :color "dark green")))
    
    ;; Activer le mode calfw-calendar
    (calfw-calendar-mode)
    
    ;; Raccourcis clavier pour calfw
    (define-key calfw-calendar-mode-map (kbd "q") 'quit-window)
    (define-key calfw-calendar-mode-map (kbd "n") 'calfw-navi-forward-day)
    (define-key calfw-calendar-mode-map (kbd "p") 'calfw-navi-backward-day)
    (define-key calfw-calendar-mode-map (kbd "f") 'calfw-navi-forward-week)
    (define-key calfw-calendar-mode-map (kbd "b") 'calfw-navi-backward-week)
    (define-key calfw-calendar-mode-map (kbd "M-n") 'calfw-navi-forward-month)
    (define-key calfw-calendar-mode-map (kbd "M-p") 'calfw-navi-backward-month)
    (define-key calfw-calendar-mode-map (kbd "g") 'calfw-navi-goto-date)
    (define-key calfw-calendar-mode-map (kbd "t") 'calfw-goto-today)
    (define-key calfw-calendar-mode-map (kbd "d") 'calfw-open-day-view)
    (define-key calfw-calendar-mode-map (kbd "w") 'calfw-open-week-view)
    (define-key calfw-calendar-mode-map (kbd "m") 'calfw-open-month-view)
    (define-key calfw-calendar-mode-map (kbd "y") 'calfw-open-year-view)
    
    ;; Fonction pour ouvrir le calendrier calfw
    (defun my-open-calfw-calendar ()
      "Ouvrir le calendrier calfw dans une nouvelle fenêtre."
      (interactive)
      (switch-to-buffer-other-window "*cfw-calendar*")
      (calfw-open-calendar-buffer))
    
    ;; Ajouter un raccourci global pour ouvrir calfw
    (global-set-key (kbd "C-c c") 'my-open-calfw-calendar)))


;; =============================================================================
;; 2. Configuration de org-gcal (Google Calendar)
;; =============================================================================

(use-package org-gcal
  :ensure t
  :after org
  :config
  ;; ==--------------------------------------------------------------------------
  ;; Configuration de base pour org-gcal
  ;; ==--------------------------------------------------------------------------
  
  ;; Répertoire pour stocker les tokens OAuth2
  (setq org-gcal-dir (expand-file-name "~/.emacs.d/org-gcal/"))
  (make-directory org-gcal-dir t)  ;; Créer le répertoire s'il n'existe pas
  
  ;; Fichier pour stocker le token OAuth2
  (setq org-gcal-token-file (expand-file-name ".org-gcal-token" org-gcal-dir))
  
  ;; ==--------------------------------------------------------------------------
  ;; Paramètres de synchronisation
  ;; ==--------------------------------------------------------------------------
  
  ;; Nombre de jours à récupérer dans le passé et le futur
  (setq org-gcal-up-days 30)    ;; 30 jours dans le passé
  (setq org-gcal-down-days 60)  ;; 60 jours dans le futur
  
  ;; Activer l'archivage automatique des anciens événements
  (setq org-gcal-auto-archive t)
  
  ;; ==--------------------------------------------------------------------------
  ;; Configuration des calendriers Google
  ;; ==--------------------------------------------------------------------------
  ;; **À compléter localement** (ne pas commiter ces valeurs !)
  ;; Remplacez les valeurs ci-dessous par vos identifiants Google Calendar
  ;; obtenus via Google Cloud Console (voir readme.org/readme.md)
  
  (setq org-gcal-client-id "YOUR_CLIENT_ID")
  (setq org-gcal-client-secret "YOUR_CLIENT_SECRET")
  
  ;; Liste des calendriers à synchroniser avec leurs fichiers Org associés
  ;; Format : '(("calendar-id" . "~/chemin/vers/fichier.org") ...)
  (setq org-gcal-fetch-file-alist
        '(("primary" . "~/org/google-calendar.org")))  ;; Calendrier principal
  
  ;; Ajouter le fichier google-calendar.org aux fichiers agenda Org
  (add-to-list 'org-agenda-files "~/org/google-calendar.org")
  
  ;; ==--------------------------------------------------------------------------
  ;; Gestion des événements
  ;; ==--------------------------------------------------------------------------
  
  ;; Mode de gestion des nouveaux événements
  (setq org-gcal-managed-newly-fetched-mode "gcal")
  
  ;; Mode de gestion des événements existants
  (setq org-gcal-managed-update-existing-mode "gcal")
  
  ;; Mode de gestion lors de la création d'événements depuis Org
  (setq org-gcal-managed-create-from-entry-mode "org")
  
  ;; Comportement lors de l'exécution de org-gcal-post-at-point
  (setq org-gcal-managed-post-at-point-update-existing 'prompt)
  
  ;; Gestion des événements récurrents
  (setq org-gcal-recurring-events-mode 'top-level)
  
  ;; ==--------------------------------------------------------------------------
  ;; Propriétés Org utilisées par org-gcal
  ;; ==--------------------------------------------------------------------------
  
  (setq org-gcal-entry-id-property "entry-id")
  (setq org-gcal-calendar-id-property "calendar-id")
  (setq org-gcal-etag-property "ETag")
  (setq org-gcal-managed-property "org-gcal-managed")
  (setq org-gcal-drawer-name "org-gcal")
  
  ;; ==--------------------------------------------------------------------------
  ;; Autres options
  ;; ==--------------------------------------------------------------------------
  
  (setq org-gcal-event-default-duration 30)
  (setq org-gcal-default-transparency "opaque")
  (setq org-gcal-notify-p t)
  (setq org-gcal-remove-api-cancelled-events 'ask)
  (setq org-gcal-update-cancelled-events-with-todo t)
  (setq org-gcal-cancelled-todo-keyword "CANCELLED")
  (setq org-gcal-remove-events-with-cancelled-todo nil)
  
  ;; ==--------------------------------------------------------------------------
  ;; Fonctions utilitaires
  ;; ==--------------------------------------------------------------------------
  
  (defun my-org-gcal-sync ()
    "Synchroniser les événements entre Org et Google Calendar."
    (interactive)
    (org-gcal-sync))
  
  (defun my-org-gcal-sync-buffer ()
    "Synchroniser uniquement le buffer Org actuel avec Google Calendar."
    (interactive)
    (org-gcal-sync-buffer))
  
  (defun my-org-gcal-post-at-point ()
    "Publier l'événement Org à la position actuelle vers Google Calendar."
    (interactive)
    (org-gcal-post-at-point))
  
  ;; ==--------------------------------------------------------------------------
  ;; Raccourcis clavier dans org-mode
  ;; ==--------------------------------------------------------------------------
  (with-eval-after-load 'org
    (define-key org-mode-map (kbd "C-c g s") 'my-org-gcal-sync)
    (define-key org-mode-map (kbd "C-c g b") 'my-org-gcal-sync-buffer)
    (define-key org-mode-map (kbd "C-c g p") 'my-org-gcal-post-at-point))
  
  ;; ==--------------------------------------------------------------------------
  ;; Intégration avec calfw (si calfw est chargé)
  ;; ==--------------------------------------------------------------------------
  (when (featurep 'calfw)
    ;; Ajouter org-gcal comme source pour calfw
    (add-to-list 'calfw-sources
                 '(calfw-org-source :name "Google Calendar" :color "dark cyan"))))


(provide 'config-calendrier)
