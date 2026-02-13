;;; FONCTIONS ET RACCOURCIS PERSONELS "S" EST LA TOUCHE WINDOWS (PEUT ENTRER EN CONFLIT AVEC LES RACCOURCIS DU WINDOW MANAGER

;; (global-set-key (kbd "s-e") 'eshell)
;; (global-set-key (kbd "s-m") 'mu4e)
;; (global-set-key (kbd "s-f") 'elfeed)
;; (global-set-key (kbd "s-d") 'dashboard-open)
;; (global-set-key (kbd "s-<f4>") 'emms)

;; (global-set-key (kbd "s-j") 'jmeteo)
;; (global-set-key (kbd "s-s") 'smeteo)

;; (global-set-key (kbd "s-q") (lambda () (interactive) (kill-buffer (current-buffer))))
;; (global-set-key (kbd "C-x s-b") 'kill-buffers-starting-with)

;; (global-set-key (kbd "s-c") 'quick-copy-line)
;; (global-set-key (kbd "s-k") 'quick-delete-line)
;; (global-set-key (kbd "s-o") 'new-empty-line-after)
;; ;; (global-set-key (kbd "s-b") 'new-empty-line-before)

;; (global-set-key (kbd "C-<return>") 'insert-indented-line-and-move)
;; (global-set-key (kbd "S-<return>") 'insert-indented-line-and-move)

;; (global-set-key (kbd "s-<up>") (lambda () (interactive) (select-window (window-in-direction 'up))))
;; (global-set-key (kbd "s-<down>") (lambda () (interactive) (select-window (window-in-direction 'down))))
;; (global-set-key (kbd "s-<left>") (lambda () (interactive) (select-window (window-in-direction 'left))))
;; (global-set-key (kbd "s-<right>") (lambda () (interactive) (select-window (window-in-direction 'right))))

;; (global-set-key (kbd "C-1") 'delete-other-windows)
;; (global-set-key (kbd "C-2") 'split-window-below)
;; (global-set-key (kbd "C-3") 'split-window-right)
;; (global-set-key (kbd "C-0") 'delete-window)

;; (global-set-key (kbd "s-<kp-add>") (lambda (g) (interactive) (enlarge-window-horizontally 3)))
;; (global-set-key (kbd "s-<kp-subtract>") (lambda () (interactive) (shrink-window-horizontally 3)))
;; (global-set-key (kbd "s-<next>") (lambda () (interactive) (enlarge-window 3)))
;; (global-set-key (kbd "s-<prior>") (lambda () (interactive) (shrink-window 3)))


;; (defun insert-indented-line-and-move ()
;;   "Insère une nouvelle ligne indentée et déplace le curseur dessus."
;;   (interactive)
;;   (end-of-line)
;;   (newline-and-indent)
;;   (beacon-blink))

;; (defun new-empty-line-before ()
;;   (interactive)
;;   (save-excursion
;;     (forward-line -1)
;;     (end-of-line)
;;     (newline-and-indent)))

;; (defun new-empty-line-after ()
;;   (interactive)
;;   (save-excursion
;;     (end-of-line)
;;     (newline-and-indent)))

;; (defun quick-copy-line ()
;;   "Copie la ligne sous le curseur dans le kill-ring"
;;   (interactive)
;;   (let ((beg (line-beginning-position 1))
;;         (end (line-beginning-position 2)))
;;     (if (eq last-command 'quick-copy-line) 
;;         (kill-append (buffer-substring beg end) (< end beg))
;;       (save-excursion (move-beginning-of-line 1)
;; 		      (beacon-blink))
;;       (kill-new (buffer-substring beg end))))
;;   ;;  (beginning-of-line 2) ; place le curseur sur la ligne suivante
;;   )

;; (defun quick-delete-line ()
;;   "Efface la ligne sous le curseur sans la mettre dans le kill-ring."
;;   (interactive)
;;   (move-beginning-of-line 1)
;;   (delete-line)
;;   (beacon-blink))

;; ;; (defun kill-buffers-starting
;; ;;   "Tue les buffers dont le nom commence par PREFIX."
;; ;;   (interactive "sKill buffers starting with: ")
;; ;;   (dolist (buffer (buffer-list))
;; ;;     (when (string-prefix-p prefix (buffer-name buffer))
;; ;;       (kill-buffer buffer)))
;; ;;   (message "Killed buffers starting with %s" prefix))
;; (defun kill-buffers-starting (prefix)
;;   "Tue les buffers dont le nom commence par PREFIX."
;;   (interactive "sKill buffers starting with: ")
;;   (dolist (buffer (buffer-list))
;;     (when (string-prefix-p prefix (buffer-name buffer))
;;       (kill-buffer buffer)))
;;   (message "Killed buffers starting with %s" prefix))
;; (defun my-org-capture-hook ()
;;   "Select the notes.org buffer after capture."
;;   (let ((buf (get-buffer "notes.org")))
;;     (when buf
;;       (select-frame-set-input-focus (get-buffer-window buf)))))

;; (defun entourer-mot-avec-parent ()
;;   (interactive)
;;   (let ((beg (point)))
;;     (forward-word)
;;     (let ((end (point)))
;;       (goto-char beg)
;;       (insert "\(")
;;       (goto-char (+ end 1))
;;       (insert "\)"))))
;; (global-set-key (kbd "s-\(") 'entourer-mot-avec-parent)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun firefox ()
;;   (interactive)
;;   (eshell-command "firefox&")) ; "&" est nécessaire pour rendre la main à emacs
;; (global-set-key (kbd "s-w") 'firefox)

;; (defun thunar ()
;;   (interactive)
;;   (eshell-command "thunar&"))
;; (global-set-key (kbd "s-t") 'thunar)

;; (defun pavucontrol ()
;;   (interactive)
;;   (eshell-command "pavucontrol&"))
;; (global-set-key (kbd "s-v") 'pavucontrol)

;; (defun kdeconnect-indicator ()
;;   (interactive)
;;   (eshell-command "kdeconnect-indicator&"))
;; (global-set-key (kbd "s-k") 'kdeconnect-indicator)
