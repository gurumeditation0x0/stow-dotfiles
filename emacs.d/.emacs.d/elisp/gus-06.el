;;; gustave-mode.el --- Mode d'écriture sans distraction -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Mode d’écriture minimaliste et stable avec :
;; - Writeroom (centrage + largeur propre)
;; - Flyspell (orthographe)
;; - Flycheck + Grammalecte (grammaire)
;; - Police configurable avec fallback
;;
;; IMPORTANT :
;; Writeroom gère déjà les marges → ne PAS les modifier à la main.
;;
;; Raccourcis :
;;   C-c g → activer gustave-mode
;;   C-c t → désactiver

;;; Code:

;; -----------------------------
;; Groupe de personnalisation
;; -----------------------------

(defgroup gustave nil
  "Mode d'écriture Gustave."
  :group 'applications)

;; -----------------------------
;; Police (simple et propre)
;; -----------------------------

(defcustom gustave-font
  '(:family "Literata" :height 120)
  "Police utilisée dans Gustave Mode."
  :type 'plist
  :group 'gustave)

;; -----------------------------
;; Variable interne
;; -----------------------------

(defvar-local gustave--saved-font nil
  "Police sauvegardée avant activation.")

;; -----------------------------
;; Hunspell (Windows)
;; -----------------------------

(cond
 ((eq system-type 'windows-nt)
  (setq ispell-program-name
        "C:/Users/david/GNU/hunspell/bin/hunspell.exe")))

(setq ispell-dictionary "fr_FR")
(setq ispell-really-hunspell t)

(setq flyspell-issue-message-flag nil)
(setq flyspell-issue-welcome-flag nil)

;; -----------------------------
;; Packages nécessaires
;; -----------------------------

(use-package writeroom-mode
  :ensure t
  :custom
  (writeroom-width 80)
  (writeroom-fullscreen-effect t)
  (writeroom-restore-window-config t)
  (writeroom-mode-line nil))

(use-package flycheck
  :ensure t)

(use-package flycheck-grammalecte
  :ensure t
  :after flycheck
  :config
  (setq flycheck-grammalecte-python-command "python")
  (setq flycheck-grammalecte-command
        "C:/Users/david/dev/grammalecte/grammalecte-cli.py")
  (flycheck-grammalecte-setup)
  ;; 🔥 autoriser dans gustave-mode
  (flycheck-add-mode 'grammalecte 'gustave-mode))

;; -----------------------------
;; Vérifier police
;; -----------------------------

(defun gustave--font-exists-p (font)
  (member font (font-family-list)))

;; -----------------------------
;; Appliquer police avec fallback
;; -----------------------------

(defun gustave--apply-font ()
  (let* ((family (plist-get gustave-font :family))
         (height (plist-get gustave-font :height))
         (fallback "Georgia")
         (final-font (if (gustave--font-exists-p family)
                         family
                       fallback)))

    (unless (gustave--font-exists-p family)
      (message "Gustave: police '%s' introuvable → fallback '%s'"
               family fallback))

    (apply #'set-face-attribute 'default nil
           (list :family final-font :height height))

    (message "Gustave: police appliquée = %s (%s)"
             final-font height)))

;; -----------------------------
;; Mode principal
;; -----------------------------

(define-derived-mode gustave-mode text-mode "Gustave"
  "Mode d’écriture sans distraction."

  ;; sauvegarde police actuelle
  (setq gustave--saved-font
        (list :family (face-attribute 'default :family)
              :height (face-attribute 'default :height)))

  (message "Gustave: police sauvegardée = %s (%s)"
           (plist-get gustave--saved-font :family)
           (plist-get gustave--saved-font :height))

  ;; appliquer police
  (gustave--apply-font)

  ;; mise en page
  (setq fill-column 80)
  (setq-local line-spacing 0.3)
  (visual-line-mode 1)

  ;; writeroom (gère marges + centrage)
  (writeroom-mode 1)

  ;; orthographe
  (flyspell-mode 1)

  ;; grammaire
  (flycheck-mode 1)
  (when (featurep 'flycheck-grammalecte)
    (flycheck-select-checker 'grammalecte))

  ;; analyse immédiate
  (flyspell-buffer)
  (flycheck-buffer)

  (message "Gustave mode activé"))

;; -----------------------------
;; Désactivation
;; -----------------------------

(defun gustave-disable ()
  "Désactive Gustave Mode."
  (interactive)

  (writeroom-mode -1)
  (flyspell-mode -1)
  (flycheck-mode -1)

  ;; restaurer police
  (when gustave--saved-font
    (apply #'set-face-attribute 'default nil gustave--saved-font)
    (message "Gustave: police restaurée = %s (%s)"
             (plist-get gustave--saved-font :family)
             (plist-get gustave--saved-font :height)))

  ;; reset locaux
  (kill-local-variable 'line-spacing)

  (text-mode)

  (message "Gustave mode désactivé"))

;; -----------------------------
;; Raccourcis
;; -----------------------------

(global-set-key (kbd "C-c g") #'gustave-mode)
(global-set-key (kbd "C-c t") #'gustave-disable)

(provide 'gustave-mode)

;;; gustave-mode.el ends here
