
;; ---------------------------
;; Recentf
;; ---------------------------
(require 'recentf)
(add-to-list 'recentf-exclude "\\ido.last\\'")
(add-to-list 'recentf-exclude "\\emms/history\\'")
(add-to-list 'recentf-exclude "\\.cache/treemacs-persist\\'")
(recentf-mode 1)

;; ---------------------------
;; Dashboard
;; ---------------------------
(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

;; ---------------------------
;; Dashboard items selon l'OS
;; ---------------------------
(pcase system-type
  ('gnu/linux
   (setq dashboard-items
         '((custom . 1)
           (custom-sunrise-sunset . 1)
           (custom-fortune . 1)
           (recents  . 8)
           (bookmarks . 8)
           (projects . 5)
           (agenda . 5)
           (registers . 5)))

   (setq dashboard-image-banner-max-height 100)
   (setq dashboard-startup-banner
         "/home/alain/dotfiles/emacs.d/.emacs.d/images/gnu-savannah.png" ))

  ('windows-nt
   (setq dashboard-items
         '((custom . 1)
           (custom-sunrise-sunset . 1)
           (recents  . 8)
           (bookmarks . 8)
           (projects . 5)
           (agenda . 5)
           (registers . 5)))

   (setq dashboard-startqup-banner 'logo))

  (_
   (setq dashboard-items '((recents . 5)))
   (setq dashboard-startup-banner 0))) ;; fallback minimal

;; ---------------------------
;; Options Dashboard communes
;; ---------------------------
(setq dashboard-set-heading-icons t
      dashboard-set-file-icons t
      dashboard-set-navigator t
      dashboard-projects-backend 'project-el
      dashboard-banner-logo-title nil)

;; ---------------------------
;; Générateurs d'items
;; ---------------------------
(defun dashboard-insert-custom (_list-size)
  (insert (current-time-string)))
(add-to-list 'dashboard-item-generators
             '(custom . dashboard-insert-custom))

(defun dashboard-insert-sunrise-sunset (_list-size)
  (insert (sunrise-sunset)))
(add-to-list 'dashboard-item-generators
             '(custom-sunrise-sunset . dashboard-insert-sunrise-sunset))

;; Fortune uniquement sous Linux
(when (eq system-type 'gnu/linux)
  (defun dashboard-insert-fortune (_list-size)
    (let ((fortune-output (shell-command-to-string "fortune")))
      (insert (propertize fortune-output
                          'face '(:foreground "green" :slant italic)))))
  (add-to-list 'dashboard-item-generators
               '(custom-fortune . dashboard-insert-fortune)))

;; wgdefault (fonction corrigée)
(defun dashboard-insert-wgdefault (_list-size)
  (let ((wgdefault-output (wg-load "~/.emacs.d/wgwindows/wg_default_start")))
    (insert (propertize wgdefault-output
                        'face '(:foreground "green" :slant italic)))))
(add-to-list 'dashboard-item-generators
             '(custom-wgdefault . dashboard-insert-wgdefault))
