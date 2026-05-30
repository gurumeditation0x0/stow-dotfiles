;; -----------------------------
;; Surlignage live mot ou mot-mot-mot
;; -----------------------------
(require 'hi-lock)

(defgroup live-smart-highlight nil
  "Smart highlight word at point."
  :group 'convenience)

(defcustom live-smart-highlight-idle-delay 0.4
  "Idle delay before highlighting."
  :type 'number)


(defvar-local live-current-highlight nil
  "Regexp currently highlighted in this buffer.")

(defvar-local live-smart-highlight-timer nil
  "Idle timer for smart highlight in this buffer.")

(defun live-smart-highlight-word-at-point ()
  "Surligne le mot ou mot-mot-mot sous le curseur dans le buffer courant."
  ;; Supprime l'ancien surlignage
  (when live-current-highlight
    (unhighlight-regexp live-current-highlight)
    (setq live-current-highlight nil))
  ;; Récupère le mot sous le curseur
  (let* ((bounds (bounds-of-thing-at-point 'symbol))
         (word (and bounds
                    (buffer-substring-no-properties
                     (car bounds) (cdr bounds)))))
    (when word
      (setq live-current-highlight
            (concat "\\b" (regexp-quote word) "\\b"))
      (highlight-regexp live-current-highlight 'hi-yellow))))

;;;###autoload
(define-minor-mode live-smart-highlight-mode
  "Surligne automatiquement le mot sous le curseur après un temps d'inactivité."
  :lighter " SH"
  (if live-smart-highlight-mode
      (setq live-smart-highlight-timer
            (run-with-idle-timer
             live-smart-highlight-idle-delay t
             (lambda ()
               (when (and live-smart-highlight-mode
                          (eq (current-buffer) (window-buffer)))
                 (live-smart-highlight-word-at-point)))))
    ;; Désactivation
    (when live-smart-highlight-timer
      (cancel-timer live-smart-highlight-timer)
      (setq live-smart-highlight-timer nil))
    (when live-current-highlight
      (unhighlight-regexp live-current-highlight)
      (setq live-current-highlight nil))))

(defun live-smart-highlight-promote-to-persistent ()
  "Rend persistant le symbole sous le curseur via highlight-symbol."
  (interactive)
  (let ((sym (thing-at-point 'symbol t)))
    (if sym
        (progn
          (highlight-symbol-at-point)
          (message "Symbole '%s' surligné de façon persistante" sym))
      (message "Aucun symbole sous le curseur"))))





