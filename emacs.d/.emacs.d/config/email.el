
(add-to-list 'load-path "~/dev/mu/build/mu4e")
(add-to-list 'load-path "/home/alain/dev/mu/build/mu")
(require 'mu4e)
(require 'mu4e-notification)
(require 'auth-source)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; List of words to colorize with their associated colors and styles.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defvar my-colored-words-list
;;   '(
;;     ("jean-marc\\|schramm" . ("red" bold nil))
;;     ("lorber\\|benoit" . ("red" bold nil))
;;     ("67 bal pap" . ("red" bold nil))
;;     ("sympodius" . ("orange" nil italic))
;;     ("emacs" . ("purple" nil italic))
;;     ("org-noveli" . ("orange" nil italic)))
;;   "Liste des mots à coloriser avec leurs couleurs et styles associés.(\"NOM\" . (\"COULEUR\" WEIGHT SLANT))")


;; (defun my-colorize-email-with-overlay ()
;;   "Colorize specific words in the current buffer using overlays."
;;   (let ((start (point-min))
;;         (end (point-max)))
;;     (dolist (liste-mots my-colored-words-list)
;;       (let* ((word (car liste-mots))
;;              (color-and-style (cdr liste-mots))
;;              (color (car color-and-style))
;;              (weight (cadr color-and-style))
;;              (style (caddr color-and-style)))
;;         (let ((case-fold-search t))
;;           (goto-char start)    ; Revenir au début du buffer pour chaque mot
;;           (while (re-search-forward word end t)
;;             (let ((overlay (make-overlay (match-beginning 0) (match-end 0))))
;;               (overlay-put overlay 'face `(:foreground ,color :weight ,weight
;;                                                        ,@(when style `(:slant ,style)))
;;               )
;;               (message "Colorized: %s" word))
;;             ;; Ne pas revenir au début ici, continuer à chercher après le mot trouvé
;;             ))))))


;; (defun my-colorize-email-with-overlay-delayed ()
;;   "Call `my-colorize-email-with-overlay` after a short delay."
;;   (run-at-time "0.3 sec" nil 'my-colorize-email-with-overlay))

;; ;; Add the function to mu4e hooks
;; (add-hook 'mu4e-view-mode-hook 'my-colorize-email-with-overlay-delayed)
;; (add-hook 'mu4e-headers-mode-hook 'my-colorize-email-with-overlay-delayed)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq mu4e-mu-binary "/home/alain/dev/mu/build/mu/mu")
(setq mu4e-headers-fields
      '((:human-date . 12)
	(:flags . 4)
	(:mailing-list . 10)
	
	(:from . 25)
	(:to . 10)
	(:subject)))
(setq mu4e-change-filenames-when-moving t)
;; (setq mu4e-update-interval (* 10 60))
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-maildir "$HOME/.Mail")
;; Make sure plain text mails flow correctly for recipients
(setq mu4e-compose-format-flowed t)
(setq message-send-mail-function 'smtpmail-send-it)
(setq mu4e-context-policy 'pick-first)
(setq user-mail-address "gurumeditation0x0@gmail.com")
;; NOTE: Only use this if you have set up a GPG key!
;; Automatically sign all outgoing mails
;; (add-hook 'message-send-hook 'mml-secure-message-sign-pgpmime)

(setq mu4e-contexts
      (list
       ;; gmail account
       (make-mu4e-context
	:name "gmail"
	:match-func
	(lambda (msg)
	  (when msg
	    (string-prefix-p "/gmail" (mu4e-message-field msg :maildir))))
	:vars '((user-mail-address . "USER@gmail.com")
		(user-full-name    . "USER@gmail.com")
		(smtpmail-auth-credentials (expand-file-name . "~/.authinfo.gpg"))
		(smtpmail-smtp-server  . "smtp.gmail.com")
		(smtpmail-smtp-service . 465)
		(smtpmail-stream-type  . ssl)
		(mu4e-compose-signature . "Guru ")
		(mu4e-trash-folder . "/gmail/\[Gmail\]/Corbeille")
		(mu4e-drafts-folder . "/gmail/\[Gmail\]/Brouillons")
		(mu4e-sent-folder  . "/gmail/\[Gmail\]/Messages envoy&AOk-s")
		(mu4e-refile-folder . "/gmail/\[Gmail\]/Tous les messages")))

       ;; Personal account
       (make-mu4e-context
	:name "Personal"
	:match-func
	(lambda (msg)
	  (when msg
	    (string-prefix-p "/free" (mu4e-message-field msg :maildir))))
	:vars '((user-mail-address . "USER@free.fr")
		(user-full-name    . "USER@free.fr")
		(smtpmail-smtp-server  . "smtp.free.fr")
		(smtpmail-smtp-service . 465)
		(setq smtpmail-free-fr-auth-credentials (list (expand-file-name "~/.authinfo.gpg")))
		(smtpmail-stream-type  . ssl)
		(mu4e-compose-signature . "USER")
		(mu4e-drafts-folder  . "/free/Drafts")
		(mu4e-sent-folder  . "/free/Sent")
		(mu4e-refile-folder  . "/free/Archive")
		(mu4e-trash-folder  . "/free/Trash")))

       ;; Laposte
       (make-mu4e-context
	:name "Laposte"
	:match-func
	(lambda (msg)
	  (when msg
	    (string-prefix-p "/laposte" (mu4e-message-field msg :maildir))))
	:vars '((user-mail-address . "USER@laposte.net")
		(user-full-name    . "USER")
		(smtpmail-smtp-server  . "smtp.laposte.net")
		(smtpmail-smtp-service . 465)
		(setq smtpmail-laposte-net-auth-credentials (list (expand-file-name "~/.authinfo")))
		(smtpmail-stream-type  . ssl)
		(mu4e-compose-signature . "USER")
		(mu4e-drafts-folder  . "/laposte/DRAFT")
		(mu4e-sent-folder  . "/laposte/OUTBOX")
		(mu4e-refile-folder  . "/laposte/QUARANTAINE")
		(mu4e-trash-folder  . "/laposte/TRASH"))))) 


(setq mu4e-maildir-shortcuts
      '(("/gmail/INBOX" . ?g)
	("/gmail/\[Gmail\]/Tous les messages" . ?a)
	("/gmail/\[Gmail\]/Brouillons" . ?d)
	("/free/INBOX" . ?f)
	("/free/Sent" . ?S)	  
	("/free/Drafts" . ?D)
	("/laposte/INBOX" . ?l)))
