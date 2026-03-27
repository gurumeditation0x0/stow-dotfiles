;;; gustave-mode.el --- Mode écriture + Org léger -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Mode hybride :
;; - Org-mode (paragraphes + structure)
;; - Writeroom (centrage)
;; - Flyspell (orthographe)
;; - Flycheck + Grammalecte (grammaire)
;; - Police configurable avec fallback
;;
;; Objectif : écrire comme dans un livre, sans distractions.
;;
;; Raccourcis :
;;   C-c g → activer gustave-mode
;;   C-c t → désactiver

;;; Code:

;; -----------------------------
;; Groupe
;; -----------------------------

(defgroup gustave nil
  "Mode d'écriture Gustave."
  :group 'applications)

;; -----------------------------
;; Police
;; -----------------------------

(defcustom gustave-font
  '(:family "Literata" :height 120)
  "Police utilisée dans Gustave Mode."
  :type 'plist
  :group 'gustave)

(defvar-local gustave--saved-font nil)

;; -----------------------------
;; Hunspell
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
;; Packages
;; -----------------------------

(use-package org
  :ensure t)

(use-package writeroom-mode
  :ensure t
  :custom
  (writeroom-width 80)
  (writeroom-fullscreen-effect nil)
  (writeroom-restore-window-config t)
  (writeroom-mode-line t))

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
  (flycheck-add-mode 'grammalecte 'gustave-mode))

;; -----------------------------
;; Vérifier police
;; -----------------------------

(defun gustave--font-exists-p (font)
  (member font (font-family-list)))

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
;; Mode principal (ORG)
;; -----------------------------

(define-derived-mode gustave-mode org-mode "Gustave"
  "Mode d’écriture basé sur Org sans distractions."

  ;; sauvegarde police
  (setq gustave--saved-font
        (list :family (face-attribute 'default :family)
              :height (face-attribute 'default :height)))

  (message "Gustave: police sauvegardée = %s (%s)"
           (plist-get gustave--saved-font :family)
           (plist-get gustave--saved-font :height))

  ;; appliquer police
  (gustave--apply-font)

  ;; -------------------------
  ;; ORG en mode discret
  ;; -------------------------

  ;; masquer étoiles
  (setq-local org-hide-leading-stars t)

  ;; indentation douce
  (org-indent-mode 1)

  ;; pas de mise en évidence agressive
  (setq-local org-startup-folded nil)

  ;; enlever distractions visuelles
  (setq-local org-ellipsis "…")

  ;; -------------------------
  ;; Écriture
  ;; -------------------------

  (visual-line-mode 1)
  (auto-fill-mode 1)

  (setq fill-column 80)
  (setq-local line-spacing 0.3)
  (setq sentence-end-double-space nil)

  ;; -------------------------
  ;; Writeroom
  ;; -------------------------

  (writeroom-mode 1)

  ;; -------------------------
  ;; Correction
  ;; -------------------------

  (flyspell-mode 1)

  (flycheck-mode 1)
  (when (featurep 'flycheck-grammalecte)
    (flycheck-select-checker 'grammalecte))

  ;; analyse initiale
  (flyspell-buffer)
  (flycheck-buffer)

  (message "Gustave mode (Org) activé"))

;; -----------------------------
;; Désactivation
;; -----------------------------

(defun gustave-disable ()
  "Quitter Gustave Mode."
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
