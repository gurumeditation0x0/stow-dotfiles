

(use-package eshell
  :init
  (setq ;; eshell-buffer-shorthand t ...  Can't see Bug#19391
   eshell-cmpl-cycle-cutoff nil
   eshell-scroll-to-bottom-on-input nil
   eshell-error-if-no-glob t
   eshell-hist-ignoredups t
   eshell-save-history-on-exit t
   eshell-prefer-lisp-functions t
   eshell-destroy-buffer-when-process-dies nil)
)

(use-package pcmpl-args)


;;(eshell/addpath "/home/niala/.local/bin")
(setq   eshell-history-file-name (concat user-emacs-directory "/eshell/history"))

(defun my-eshell-key ()
  "My hook for customizing eshell history mode."
  (define-key eshell-hist-mode-map (kbd "<up>") nil)
  (define-key eshell-hist-mode-map (kbd "<down>") nil)
  (define-key eshell-hist-mode-map (kbd "C-<up>")
    #'eshell-previous-matching-input-from-input)
  (define-key eshell-hist-mode-map (kbd "C-<down>")
	      #'eshell-next-matching-input-from-input))

(add-hook 'eshell-hist-mode-hook 'my-eshell-key)

(load-file (concat  user-emacs-directory "/elisp/eshell-git-prompt.el"))
(eshell-git-prompt-use-theme 'multiline)

;; (add-to-list 'eshell-modules-list 'eshell-tramp)
;; (setq shell-kill-buffer-on-exit t)

(use-package eat
  :ensure t
  :config
  (eat-eshell-mode)
  (setq eshell-visual-commands '()))
(add-hook 'eshell-load-hook #'eat-eshell-mode)
;; (use-package eshell-git-prompt
;; 	       :config
;; 	       (eshell-git-prompt-use-theme 'multiline))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Correction du bug affichage lors des apt
;; https://oremacs.com/2019/03/24/shell-apt/ 
(advice-add
 'ansi-color-apply-on-region
 :before 'ora-ansi-color-apply-on-region)

(defun ora-ansi-color-apply-on-region (begin end)
  "Fix progress bars for e.g. apt(8).
Display progress in the mode line instead."
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
  (setq mode-line-process
        (if (string-match
             "Progress: \\[ *\\([0-9]+\\)%\\]" progress)
            (list
             (concat ":%s "
                     (match-string 1 progress)
                     "%%%% "))
          '(":%s")))
  (force-mode-line-update))
