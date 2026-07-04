;;; config-gcal.el --- Configuration pour org-gcal (Google Calendar) -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration de org-gcal pour la synchronisation entre Org et Google Calendar.
;; Basé sur la documentation : https://github.com/emacsmirror/org-gcal

;;; Code:

(use-package org-gcal
  :ensure t
  :after org
  :config
  ;; =============================================================================
  ;; Configuration de base pour org-gcal
  ;; =============================================================================
  
  ;; Répertoire pour stocker les tokens OAuth2
  (setq org-gcal-dir (expand-file-name "~/.emacs.d/org-gcal/"))
  (make-directory org-gcal-dir t t)  ;; Créer le répertoire s'il n'existe pas
  
  ;; Fichier pour stocker le token OAuth2
  (setq org-gcal-token-file (expand-file-name ".org-gcal-token" org-gcal-dir))
  
  ;; =============================================================================
  ;; Paramètres de synchronisation
  ;; =============================================================================
  
  ;; Nombre de jours à récupérer dans le passé et le futur
  (setq org-gcal-up-days 30)    ;; 30 jours dans le passé
  (setq org-gcal-down-days 60)  ;; 60 jours dans le futur
  
  ;; Activer l'archivage automatique des anciens événements
  (setq org-gcal-auto-archive t)
  
  ;; =============================================================================
  ;; Configuration des calendriers Google
  ;; =============================================================================
  ;; Remplacez les valeurs ci-dessous par vos identifiants Google Calendar
  ;; Ces valeurs doivent être obtenues via Google Cloud Console
  ;; (Voir la documentation dans readme.org/readme.md)
  
  ;; Client ID et Client Secret pour OAuth2
  ;; **À compléter localement** (ne pas commiter ces valeurs !)
  (setq org-gcal-client-id "YOUR_CLIENT_ID")
  (setq org-gcal-client-secret "YOUR_CLIENT_SECRET")
  
  ;; Liste des calendriers à synchroniser avec leurs fichiers Org associés
  ;; Format : '(("calendar-id" . "~/chemin/vers/fichier.org") ...)
  (setq org-gcal-fetch-file-alist
        '(("primary" . "~/org/google-calendar.org")))  ;; Calendrier principal
  
  ;; Ajouter le fichier google-calendar.org aux fichiers agenda Org
  (add-to-list 'org-agenda-files "~/org/google-calendar.org")
  
  ;; =============================================================================
  ;; Gestion des événements
  ;; =============================================================================
  
  ;; Mode de gestion des nouveaux événements (par défaut : gcal)
  ;; - "gcal" : Les événements sont gérés principalement par Google Calendar
  ;; - "org"  : Les événements sont gérés principalement par Org
  (setq org-gcal-managed-newly-fetched-mode "gcal")
  
  ;; Mode de gestion des événements existants
  (setq org-gcal-managed-update-existing-mode "gcal")
  
  ;; Mode de gestion lors de la création d'événements depuis Org
  (setq org-gcal-managed-create-from-entry-mode "org")
  
  ;; Comportement lors de l'exécution de org-gcal-post-at-point sur des entrées existantes
  (setq org-gcal-managed-post-at-point-update-existing 'prompt)
  
  ;; Gestion des événements récurrents
  (setq org-gcal-recurring-events-mode 'top-level)  ;; Insérer au niveau supérieur
  
  ;; =============================================================================
  ;; Propriétés Org utilisées par org-gcal
  ;; =============================================================================
  
  ;; Propriété pour stocker l'ID de l'entrée
  (setq org-gcal-entry-id-property "entry-id")
  
  ;; Propriété pour stocker l'ID du calendrier
  (setq org-gcal-calendar-id-property "calendar-id")
  
  ;; Propriété pour stocker l'ETag (pour la synchronisation)
  (setq org-gcal-etag-property "ETag")
  
  ;; Propriété pour indiquer comment l'événement est géré
  (setq org-gcal-managed-property "org-gcal-managed")
  
  ;; Nom du tiroir pour les métadonnées des événements
  (setq org-gcal-drawer-name "org-gcal")
  
  ;; =============================================================================
  ;; Autres options
  ;; =============================================================================
  
  ;; Durée par défaut des événements (en minutes)
  (setq org-gcal-event-default-duration 30)
  
  ;; Transparence par défaut pour les nouveaux événements
  (setq org-gcal-default-transparency "opaque")
  
  ;; Désactiver les notifications (optionnel)
  (setq org-gcal-notify-p t)
  
  ;; Supprimer les événements annulés dans Google Calendar
  (setq org-gcal-remove-api-cancelled-events 'ask)
  
  ;; Mettre à jour les événements avec le mot-clé TODO "CANCELLED"
  (setq org-gcal-update-cancelled-events-with-todo t)
  (setq org-gcal-cancelled-todo-keyword "CANCELLED")
  
  ;; Supprimer les événements avec le mot-clé TODO "CANCELLED"
  (setq org-gcal-remove-events-with-cancelled-todo nil)
  
  ;; =============================================================================
  ;; Fonctions utilitaires
  ;; =============================================================================
  
  ;; Fonction pour synchroniser manuellement avec Google Calendar
  (defun my-org-gcal-sync ()
    "Synchroniser les événements entre Org et Google Calendar."
    (interactive)
    (org-gcal-sync))
  
  ;; Fonction pour synchroniser uniquement le buffer actuel
  (defun my-org-gcal-sync-buffer ()
    "Synchroniser uniquement le buffer Org actuel avec Google Calendar."
    (interactive)
    (org-gcal-sync-buffer))
  
  ;; Fonction pour publier l'événement à la position actuelle
  (defun my-org-gcal-post-at-point ()
    "Publier l'événement Org à la position actuelle vers Google Calendar."
    (interactive)
    (org-gcal-post-at-point))
  
  ;; =============================================================================
  ;; Raccourcis clavier
  ;; =============================================================================
  
  ;; Ajouter des raccourcis pour org-gcal dans org-mode
  (with-eval-after-load 'org
    (define-key org-mode-map (kbd "C-c g s") 'my-org-gcal-sync)
    (define-key org-mode-map (kbd "C-c g b") 'my-org-gcal-sync-buffer)
    (define-key org-mode-map (kbd "C-c g p") 'my-org-gcal-post-at-point))
  
  ;; =============================================================================
  ;; Intégration avec calfw (si calfw est chargé)
  ;; =============================================================================
  (when (featurep 'calfw)
    ;; Ajouter org-gcal comme source pour calfw
    (add-to-list 'calfw-sources
                 '(calfw-org-source :name "Google Calendar" :color "dark cyan")))
)

(provide 'config-gcal)
