;;; config-org.el --- Org general config -*- lexical-binding: t; -*-

;; Affichage.
(setq org-src-fontify-natively t)
(setq org-startup-with-inline-images t)
(setq org-image-actual-width nil)
(setq org-show-notification-handler 'ignore)
(setq org-image-max-width nil)
(setq org-return-follows-link t)
(setq org-link-descriptive t)

;; Répertoire org.
(setq org-image-actual-width nil)
(setq org-directory "~/org/")

;; TODO
;; Liste des fichiers avec les tâches à faire.
(setq org-agenda-files (list "~/org/taches1.org"
                             "~/org/taches2.org"
                             ))

(setq org-todo-keywords
      '((sequence "A FAIRE" "EN COURS" "|" "FAIT" "ABANDONNÉ")))

(setq org-todo-keyword-faces
      '(("A FAIRE" . org-warning)
        ("EN COURS" . "yellow")
	("FAIT" . "green")
        ("ABANDONNÉ" . "gray")))

;; Style.
(setq org-hide-emphasis-markers nil
      org-descriptive-links t
      org-hide-leading-stars nil)

;; ;; Permet de n'afficher que les tâches importantes.
;;  '(org-agenda-custom-commands
;;    (quote
;;     (("1" "Tâches prioritaires"
;;       ((search "O [#A" nil))
;;       nil))))

;; Images auto-refresh après exécution Babel.
(add-hook 'org-babel-after-execute-hook #'org-display-inline-images)

(provide 'config-org)
