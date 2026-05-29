(use-package perspective
   :ensure t
   :custom
   (persp-mode-prefix-key (kbd "C-c P"))
  :init
  (persp-mode)
  (setq persp-state-default-file
        (locate-user-emacs-file "persp-state.el"))

  :config

  ;; 1. chargement du state au démarrage
  (add-hook 'emacs-startup-hook
            (lambda ()
              (when (file-exists-p persp-state-default-file)
                (persp-state-load persp-state-default-file))))

  ;; 2. une fois chargé → switch vers "main"
  (add-hook 'persp-after-load-state-hook
            (lambda ()
              (when (persp-get-by-name "main")
                (persp-switch "main")))))

(add-to-list 'default-frame-alist '(fullscreen . nil))
(add-to-list 'default-frame-alist '(width . (text-pixels . 1500)))
(add-to-list 'default-frame-alist '(height . (text-pixels . 800)))

(add-to-list 'default-frame-alist '(top . 100))
(add-to-list 'default-frame-alist '(left . 100))
