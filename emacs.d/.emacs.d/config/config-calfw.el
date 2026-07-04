;;; config-calfw.el --- Configuration pour calfw (Calendar Framework) -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration de calfw pour l'affichage des agendas dans Emacs.
;; calfw est un framework qui permet d'afficher les événements de différents calendriers
;; (Google Calendar, Org, etc.) dans une vue unifiée.

;;; Code:

(use-package calfw
  :ensure t
  :after org
  :config
  ;; Charger les modules nécessaires pour calfw
  (require 'calfw-cal)
  (require 'calfw-org)
  
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
  ;; Ajouter Org comme source de données
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
  (global-set-key (kbd "C-c c") 'my-open-calfw-calendar)
)

(provide 'config-calfw)
