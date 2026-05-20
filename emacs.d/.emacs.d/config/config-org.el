;;; config-org.el --- Org general config -*- lexical-binding: t; -*-

;; Affichage de base
(setq org-src-fontify-natively t)
(setq org-startup-with-inline-images t)
(setq org-show-notification-handler 'ignore)

;; Répertoire org
(setq org-directory "~/org/")

;; TODO keywords
(setq org-todo-keywords
      '((sequence "A FAIRE" "EN COURS" "|" "FAIT" "ABANDONNÉ")))

(setq org-todo-keyword-faces
      '(("A FAIRE" . org-warning)
        ("EN COURS" . "yellow")
        ("ABANDONNÉ" . "gray")))

;; Style minimal (tu peux garder ou simplifier)
(setq org-hide-emphasis-markers nil
      org-descriptive-links t
      org-hide-leading-stars nil)

;; Images auto-refresh après exécution Babel
(add-hook 'org-babel-after-execute-hook #'org-display-inline-images)

(provide 'config-org)
