
;; (defun gustave-mode ()
;;   "Bascule entre GustaveMode activé et désactivé."
;;   (use-package writeroom-mode)
;;   (interactive)
;;   (if (eq major-mode 'gustave-mode)
;;       (progn
;;         (writeroom-mode -1)
;;         (flyspell-mode -1)
;;         (flycheck-mode -1)
;;         (setq major-mode 'text-mode)
;;         (setq mode-name "Text")
;; 	(set-face-attribute 'default nil :family "Ubuntu" :height 120))
;;     (progn
;;         (load-file  "~/.emacs.d/elisp/org-novelist.el")
;;       (writeroom-mode 1)
;;       (flyspell-mode 1)
;;       (flycheck-mode 1)
;;       (setq major-mode 'gustave-mode)
;;       (setq mode-name "GustaveMode")
;;       ;; (set-frame-font "URW Bookman Light-15"))))
;;       ;; (set-face-font "Ubuntu")
;;       ;; (set-face-attribute 'default nil :family "urw-P052" :height 140)))) 
;;       (set-face-attribute 'default nil :family "GaramondLibre-Regular" :height 120))))

;; ;; (add-to-list 'auto-mode-alist '("\\.txt\\'" . mon-super-mode)) ; Associer le mode à des fichiers avec l'extension .txt
;; ;; (define-key ctl-x-map (kbd "C-c g") 'gustave-mode-toggle)
;; Définition du mode Gustave avec correction orthographique et Grammalecte

(use-package flycheck-grammalecte
             :hook (fountain-mode . flycheck-mode)
             :init
             (setq flycheck-grammalecte-report-apos nil
                   flycheck-grammalecte-report-esp nil
                   flycheck-grammalecte-report-nbsp nil)
             :config
             (add-to-list 'flycheck-grammalecte-enabled-modes 'fountain-mode)
             (grammalecte-download-grammalecte)
             (flycheck-grammalecte-setup))


(define-derived-mode gustave-mode text-mode "GustaveMode"
  "Un mode majeur dédié à l'écriture sans distraction avec Flyspell, Flycheck et Grammalecte."
  ;; Charger les outils nécessaires pour l'écriture
  (load-file "~/.emacs.d/elisp/org-novelist.el")
  ;; Activer writeroom-mode pour un environnement sans distraction
  (writeroom-mode 1)
  ;; Configurer la correction orthographique avec Flyspell
  (flyspell-mode 1)
  (setq ispell-program-name (executable-find "hunspell")
        ispell-really-hunspell t
        ispell-dictionary "fr-classique")
  ;; Configurer Flycheck avec Grammalecte
  (flycheck-mode 1)
  (if (featurep 'flycheck-grammalecte)
      (progn
;;        (unless (file-exists-p (concat flycheck-grammalecte-path "/grammalecte/"))
	          (unless (file-exists-p (concat flycheck-grammalecte-path "/home/alain/.emacs.d/elpa/flycheck-grammalecte-20230605.1035/grammalecte"))
          (grammalecte-download-grammalecte))
        (flycheck-grammalecte-setup))
  ;; Appliquer les réglages de la police pour une meilleure lisibilité
  (set-face-attribute 'default nil :family "GaramondLibre-Regular" :height 120)))

(defun disable-gustave-mode ()
  "Désactive Gustave Mode et réinitialise les paramètres."
  (interactive)
  (writeroom-mode -1)
  (flyspell-mode -1)
  (flycheck-mode -1)
  (text-mode)
  (set-face-attribute 'default nil :family "Ubuntu" :height 120))

;; Associer une extension de fichier à Gustave Mode
(add-to-list 'auto-mode-alist '("\\.gustave\\'" . gustave-mode))

;; Associer des raccourcis pour activer/désactiver Gustave Mode
(define-key global-map (kbd "C-c g") 'gustave-mode)
;;(define-key global-map (kbd "C-c t") 'disable-gustave-mod

