;;; early-init.el --- Early initialization for Emacs -*- lexical-binding: t; -*-
;;; License: GPLv3
;;; Chargé avant init.el pour optimiser le démarrage

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. Accélération du démarrage (GC)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Très haut GC pendant le startup pour éviter les pauses
(setq gc-cons-threshold (* 50 1000 1000)) ;; 50 MB
(setq gc-cons-percentage 0.6)

;; Restaurer GC normal après init pour stabilité
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1000 1000)) ;; 16 MB
            (setq gc-cons-percentage 0.1)
            (garbage-collect)
            (message "GC restauré à 16MB après démarrage")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. Détection de l'OS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (setq my-os
;;       (cond
;;        ((defconst windows (eq system-type 'windows-nt)))
;;        ((defconst linux   (eq system-type 'gnu/linux)))
;;        (t 'unknown)))

(setq my-os
      (cond
       ((eq system-type 'windows-nt) 'windows)
       ((eq system-type 'gnu/linux)  'linux)
       (t 'unknown)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. Définition des répertoires
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq user-emacs-directory
      (expand-file-name
       (cond
        ((eq my-os 'windows)
         (concat (getenv "USERPROFILE") "/.emacs.d"))
        (t
         (concat (getenv "HOME") "/.emacs.d")))))

(setq home-dir 
      (cond
       ((eq system-type 'windows-nt) (getenv "USERPROFILE"))
       ((eq system-type 'gnu/linux)  (getenv "HOME"))))
       
(message home-dir)


(setq org-directory (concat home-dir "/org/"))
(setq my-elisp-dir (concat user-emacs-directory "/elisp"))
(setq my-config-dir (concat user-emacs-directory "/config"))
(setq my-dev-dir (concat home-dir "/dev"))

(add-to-list 'load-path my-elisp-dir)
(add-to-list 'load-path my-config-dir)
(add-to-list 'load-path my-dev-dir)

;; (when (eq system-type 'windows-nt)
;;   (add-to-list 'exec-path "C:/Program Files/Git/usr/bin"))


;; Ajout des chemin vers git et ses utilitaires (diff.exe ...)
;; (when (eq system-type 'windows-nt)
;; 	  (setenv "PATH" 
;; 		  (concat
;; 		   "C:/Program Files/Git/usr/bin/" path-separator
;; 		   (getenv "PATH")))
;; 	  (add-to-list 'exec-path "C:/Program Files/Git/usr/bin/"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4. PowerShell / shell UTF-8 (Windows)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (when (eq my-os 'windows-nt)
;;   ;; Choisir PowerShell si présent
;;   (let ((xlist
;;          '("~/AppData/Local/Microsoft/WindowsApps/pwsh.exe"
;;            "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"))
;;         xfound)
;;     (setq xfound (seq-some (lambda (x) (when (file-exists-p x) x)) xlist))
;;     (when xfound
;;       (setq explicit-shell-file-name xfound))))

;; Forcer UTF-8 pour tous les processus
(setq locale-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. Interface graphique minimale
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-screen t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 6. Langue et encodage (UTF-8 complet)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setenv "LANG" "fr_FR.UTF-8")
(setq system-time-locale "fr_FR.UTF-8")
(set-language-environment "French")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(setq-default buffer-file-coding-system 'utf-8-unix)
(setq require-final-newline t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 7. Police adaptée pour accents et emoji
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (cond
;;  ((eq my-os 'windows)   ;; Windows
;;   (set-face-attribute 'default nil
;;                       :family "Consolas"
;;                       :height 100)
;;   ;; Emoji si besoin
;;   ;; (set-fontset-font t 'Emojis"Segoe UI Emoji" nil 'prepend))
;;   )
;;  ((eq my-os 'gnu/linux)
;;   (set-face-attribute 'default nil
;;                       :family "Consolas"
;;                       :height 120)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 8. Paramètres généraux
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq custom-file (expand-file-name "emacs-custom.el" user-emacs-directory))
(setq frame-title-format '("@" system-name " : %b (%f)"))

(delete-selection-mode 1)
(global-auto-revert-mode nil)
(global-visual-line-mode 1)

(setq debug-on-error nil
      mouse-autoselect-window t
      vc-follow-symlinks t
      bookmark-save-flag 1
      register-preview-delay 0.8
      register-preview-function #'consult-register-format
      compilation-scroll-output t
      mouse-yank-at-point t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 9. Calendrier et lever/coucher soleil (Strasbourg)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq calendar-latitude 48.584667
      calendar-longitude 7.736424
      calendar-location-name "Strasbourg, FR")

;; Heure 24h dans la mode line
(setq display-time-24hr-format t)
(setq display-time-format "%H:%M")
(display-time-mode 1)

;; Heure 24h pour calendrier / solar
(setq calendar-time-display-form
      '(24-hours ":" minutes
                  (if time-zone " (" time-zone ")")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 10. Gestion minimale des packages (Emacs 30+)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
(require 'use-package)
(setq use-package-always-ensure t)
