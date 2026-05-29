;;; config-denote.el --- Denote configuration -*- lexical-binding: t; -*-
;;; License: GPLv3

;; --------------------------------------------------
;; Windows username (WSL only)
;; --------------------------------------------------

;; (defvar my-windows-username
;;   (when (and (boundp 'my-os)
;;              (symbolp my-os)
;;              (string-prefix-p "wsl-" (symbol-name my-os)))
;;     (string-trim
;;      (shell-command-to-string
;;       "env -i /mnt/c/Windows/System32/cmd.exe /c echo %USERNAME%")))
;;   "Nom utilisateur Windows en WSL.")

;; ;; fallback si échec
;; (unless (and my-windows-username
;;              (not (string-empty-p my-windows-username)))
;;   (setq my-windows-username "david")) ;; fallback safe

;; --------------------------------------------------
;; Denote directory
;; --------------------------------------------------

(defvar my-denote-directory
  (expand-file-name
   (cond
    ;; Windows natif
    ((eq my-os 'windows)
     (expand-file-name "Documents/Denote" home-dir))

    ;; WSL
    ((and (symbolp my-os)
          (string-prefix-p "wsl-" (symbol-name my-os)))
     (expand-file-name
      (format "/mnt/c/Users/%s/Documents/Denote"
              my-windows-username)))

    ;; Linux natif
    ((eq my-os 'linux)
     (expand-file-name "Documents/Denote" home-dir))

    ;; fallback
    (t
     (expand-file-name "Documents/Denote" home-dir))))
  "Répertoire Denote selon OS.")

(message "my-os = %s" my-os)
(message "my-windows-username = %s" my-windows-username)
(message "Denote directory = %s" my-denote-directory)

;; --------------------------------------------------
;; Denote
;; --------------------------------------------------

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
  :bind
  (("C-c n n" . denote)
   ("C-c n r" . denote-rename-file)
   ("C-c n l" . denote-link)
   ("C-c n b" . denote-backlinks)
   ("C-c n d" . denote-dired)
   ("C-c n g" . denote-grep))
  :config
  (setq denote-directory my-denote-directory)
  (denote-rename-buffer-mode 1))

;; --------------------------------------------------
;; Provide
;; --------------------------------------------------

(provide 'config-denote)

;;; config-denote.el ends here
