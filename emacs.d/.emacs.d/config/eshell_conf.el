;;; ===========================
;;; Eshell & PowerShell Setup
;;; Cross-platform (Windows & Linux)
;;; ===========================

;; ---------------------------
;; Eshell configuration
;; ---------------------------
(use-package eshell
  :init
  ;; Paramètres généraux d'Eshell
  (setq
   eshell-cmpl-cycle-cutoff nil               ; Ne pas limiter l'auto-complétion
   eshell-scroll-to-bottom-on-input nil       ; Ne pas scroller automatiquement en bas
   eshell-error-if-no-glob t                  ; Erreur si glob invalide
   eshell-hist-ignoredups t                   ; Ignorer les doublons dans l'historique
   eshell-save-history-on-exit t              ; Sauvegarder l'historique à la sortie
   eshell-prefer-lisp-functions t             ; Prioriser les fonctions Lisp sur les binaires
   eshell-destroy-buffer-when-process-dies nil
   eshell-history-file-name (concat user-emacs-directory "/eshell/history"))
  ;; :config
  ;; (with-eval-after-load 'eshell
  ;;   (when (boundp 'eshell-hist-mode-map)
  ;; (define-key eshell-hist-mode-map (kbd "<up>") nil)
  ;; (define-key eshell-hist-mode-map (kbd "<down>") nil)
  ;; (define-key eshell-hist-mode-map (kbd "C-<up>") #'eshell-previous-matching-input-from-input)
  ;; (define-key eshell-hist-mode-map (kbd "C-<down>") #'eshell-next-matching-input-from-input)))
  )

(use-package pcmpl-args) ; Complétion avancée des arguments

;; ---------------------------
;; Eshell Git prompt
;; ---------------------------
(load-file (concat user-emacs-directory "/elisp/eshell-git-prompt.el"))
(eshell-git-prompt-use-theme 'multiline) ; thème multiline

;; ---------------------------
;; Eat : exécution de commandes visuelles (comme top, htop)
;; ---------------------------
(use-package eat
  :ensure t
  :config
  (eat-eshell-mode)
  (setq eshell-visual-commands '()))
(add-hook 'eshell-load-hook #'eat-eshell-mode)

;; ---------------------------
;; Correction du bug d'affichage des barres de progression (apt, etc.)
;; https://oremacs.com/2019/03/24/shell-apt/
;; ---------------------------
(advice-add 'ansi-color-apply-on-region :before 'ora-ansi-color-apply-on-region)

(defun ora-ansi-color-apply-on-region (begin end)
  "Fix progress bars for apt(8), display progress in mode line."
  (let ((end-marker (copy-marker end))
        mb)
    (save-excursion
      (goto-char (copy-marker begin))
      (while (re-search-forward "\0337" end-marker t)
        (setq mb (match-beginning 0))
        (when (re-search-forward "\0338" end-marker t)
          (ora-apt-progress-message
           (substring-no-properties
            (delete-and-extract-region mb (point))
            2 -2)))))))

(defun ora-apt-progress-message (progress)
  "Afficher la progression dans la mode-line."
  (setq mode-line-process
        (if (string-match "Progress: \\[ *\\([0-9]+\\)%\\]" progress)
            (list (concat ":%s " (match-string 1 progress) "%%%% "))
          '(":%s")))
  (force-mode-line-update))

;; ---------------------------
;; PowerShell setup (Windows only)
;; ---------------------------
(use-package powershell
  :ensure t
  :mode ("\\.ps1\\'" . powershell-mode)
  :init
  (when (eq system-type 'windows-nt)
    ;; Détecte PowerShell 7+ ou fallback vers PowerShell classique
    (setq powershell-executable
          (or (executable-find "pwsh")
              "C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")))

  :config
  ;; Arguments pour M-x powershell
  (setq powershell-shell-args '("-NoLogo" "-NoExit" "-Command" "-"))
  
  ;; Message pour confirmer le chargement
  (message "powershell.el chargé : mode PowerShell prêt à l'emploi"))

(defun my-eshell-key ()
  "My hook for customizing eshell history mode."
  (define-key eshell-hist-mode-map (kbd "<up>") nil)
  (define-key eshell-hist-mode-map (kbd "<down>") nil)
  (define-key eshell-hist-mode-map (kbd "C-<up>")
    #'eshell-previous-matching-input-from-input)
  (define-key eshell-hist-mode-map (kbd "C-<down>")
	      #'eshell-next-matching-input-from-input))

(add-hook 'eshell-hist-mode-hook 'my-eshell-key)
