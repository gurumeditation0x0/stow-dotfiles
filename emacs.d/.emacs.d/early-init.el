
;;; early-init.el --- Early initialization for Emacs -*- lexical-binding: t; -*-
;;; License: GPLv3
;;; This file is loaded before init.el to optimize startup performance


;;; early-init.el -*- lexical-binding: t; -*-

;; Détection OS
(setq my-os
      (cond
       ((eq system-type 'windows-nt) 'windows)
       ((eq system-type 'gnu/linux)  'linux)
       ((eq system-type 'darwin)     'mac)
       (t 'unknown)))

;; Définition du user-emacs-directory.
(setq user-emacs-directory
      (expand-file-name
       (cond
        ((eq my-os 'windows)
         (concat (getenv "USERPROFILE") "/.emacs.d"))
        (t
         (concat (getenv "HOME") "/.emacs.d")))))


(setq home-dir "~") ;; home 
(setq org-directory (concat home-dir "/org/"))
;;(setq custom-file (concat user-emacs-directory "/emacs-custom.el"))
(setq my-elisp-dir (concat user-emacs-directory "/elisp")) ;; pour tes fichiers elisp
(setq my-config-dir (concat user-emacs-directory "/config")) ;; pour tes fichiers conf
(setq my-dev-dir (concat home-dir "/dev")) ;; pour tes fichiers dev

(message "home dir %s" home-dir)
(message "emacs directory %s" user-emacs-directory)

;; Ajouter dossier elisp au load-path
(add-to-list 'load-path my-elisp-dir)
(add-to-list 'load-path my-config-dir)
(add-to-list 'load-path my-dev-dir)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Accélération du démarrage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Augmenter temporairement le seuil du garbage collector
;; pour éviter les pauses pendant le chargement des packages
(setq gc-cons-threshold (* 50 1000 1000)) ;; 50 MB
(setq gc-cons-percentage 0.6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI elements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Désactiver dès le début les éléments graphiques
(tool-bar-mode -1)       ;; Barre d'outils
(scroll-bar-mode -1)     ;; Barres de défilement
(menu-bar-mode -1)       ;; Barre de menu
(setq inhibit-startup-screen t)

;; Définir les paramètres par défaut des frames
;; (setq default-frame-alist
;;       '((alpha . (85 . 50))   ;; Transparence (85% / 50%)
;;         ;; (font . "Ubuntu-12") ;; Police par défaut si souhaitée
;;         ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Langue et encodage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (set-language-environment "French")
;; (prefer-coding-system 'utf-8)
;; (setq default-buffer-file-coding-system 'utf-8)
;; (setq coding-system-for-write 'utf-8)
;; (setq buffer-file-coding-system 'utf-8)
;; (setq-default buffer-file-coding-system 'utf-8-unix)
;; (setq save-buffer-coding-system 'utf-8-unix)
;; (setq require-final-newline t)


(setenv "LANG" "fr_FR.UTF-8")
(setq system-time-locale "fr_FR.UTF-8")

;; Langue d'Emacs
(set-language-environment "French")

;; Encodage UTF-8 global
(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq coding-system-for-write 'utf-8)
(setq buffer-file-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)
(setq save-buffer-coding-system 'utf-8-unix)

(setq require-final-newline t)

(setq custom-file "~/.emacs.d/emacs-custom.el")
(setq frame-title-format (list "@" system-name " : %b (%f)"))
(setq inhibit-startup-screen t)

(delete-selection-mode 1)
(global-auto-revert-mode 1)
(setq debug-on-error nil
      mouse-autoselect-window t
      vc-follow-symlinks t
      bookmark-save-flag 1
      register-preview-delay 0.8
      register-preview-function #'consult-register-format
      compilation-scroll-output t
      mouse-yank-at-point t)

(global-visual-line-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Définir les coordonnées de Strasbourg pour le calendrier / sunrise-sunset
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq calendar-latitude 48.584667    ;; latitude
      calendar-longitude 7.736424    ;; longitude
      calendar-location-name "Strasbourg, FR")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package management minimal (Emacs 30+)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; use-package natif depuis Emacs 30+
(require 'use-package)
(setq use-package-always-ensure t)
