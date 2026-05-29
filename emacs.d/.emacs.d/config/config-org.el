;;; config-org.el --- Org general config -*- lexical-binding: t; -*-

(use-package htmlize
  :ensure t)


;; Affichage de base
(setq org-src-fontify-natively t)
(setq org-startup-with-inline-images t)
(setq org-show-notification-handler 'ignore)

;; Paramètres visuels et fontification
;; (custom-set-variables '(org-fontify-quote-and-verse-blocks t))
;; (custom-set-faces
;;  '(org-level-1 ((t (:inherit outline-1 :family "Ubuntu" :height 1.6))))
;;  '(org-level-2 ((t (:inherit outline-1 :family "Ubuntu" :height 1.4))))
;;  '(org-level-3 ((t (:inherit outline-3 :family "Ubuntu" :height 1.2))))
;;  '(org-level-4 ((t (:inherit outline-4 :family "Ubuntu" :height 1.1))))
;;  '(org-level-5 ((t (:inherit outline-5 :family "Ubuntu" :height 1.1)))))

;; Répertoire org
(setq org-directory "~/org/")

;; Joue un son quand  org-timer est fini.
(add-hook 'org-timer-done-hook (lambda ()
				 (shell-command "mplayer -really-quiet ~/dev/Cloches/RcsaQuartdHeure.wav")))


;; TODO keywords
(setq org-todo-keywords
      '((sequence "A FAIRE" "EN COURS" "|" "FAIT" "ABANDONNÉ")))

(setq org-todo-keyword-faces
      '(("A FAIRE" . org-warning)
        ("EN COURS" . "yellow")
        ("ABANDONNÉ" . "gray")))

;; Style minimal
(setq org-hide-emphasis-markers nil
      org-descriptive-links t
      org-hide-leading-stars nil)

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


(provide 'config-org)
