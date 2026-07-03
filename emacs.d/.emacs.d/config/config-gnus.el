;;; config-gnus.el --- Description -*- lexical-binding: t; -*-

;;; Commentary:

;; 

;;; Code:

;;; ---------------------------
;;; Gnus multi-IMAP 
;;; ---------------------------
;;;
;;; ---------------------------
;;; ATTENTION !!! Il faut générer les clés gpg.
;;; (gpg doit être dans le PATH)
;;;
;;; Pour créer les clés:
;;
;;gpg --quick-generate-key "Alain <exemple@gmail.com>" rsa4096 cert,sign,encr 0
;;
;;; Pour chiffrer .authinfo: 
;;; (.authinfo doit être stricte sans lignes vides sous Windows.)
;;
;; gpg --encrypt --recipient exemple@mail.fr .authinfo


;; ---------------------------
;; Joindre / supprimer pièces jointes
;; ---------------------------
;; C-c C-a pour attacher, C-c C-k pour supprimer

(require 'gnus)
(require 'message)
(require 'smtpmail)
(require 'epa-file)
(require 'auth-source)

;; Pour que les pièces jointes soient envoyées et non jouées à cause de OpenWith.
(add-to-list  'mm-inhibit-file-name-handlers 'openwith-file-handler)

(pcase system-type
  ('gnu/linux
   (epa-file-enable)
   (setq auth-sources '("~/.authinfo.gpg"))
   (setq epg-pinentry-mode 'loopback))

  ('windows-nt
   (epa-file-enable)
   (setq auth-sources
	 (list (concat (getenv "USERPROFILE") "/.authinfo.gpg"))))
  (_
   (error "OS non défini ou non supporté pour auth-sources: %s" my-os)))


;; ---------------------------
;; SMTP pour envoi
;; ---------------------------
(setq message-send-mail-function 'smtpmail-send-it)

(setq my-mail-accounts
      '(("Free" "@free.fr" "smtp.free.fr" 587)
        ("Laposte" "@laposte.net" "smtp.laposte.net" 587)
        ("Gmail" "@gmail.com" "smtp.gmail.com" 587)))

(defun my-choose-mail-account ()
  "Choisir manuellement l'adresse From et le SMTP."
  (interactive)
  (let* ((choice (completing-read "From account: " (mapcar #'car my-mail-accounts)))
         (account (assoc choice my-mail-accounts)))
    (when account
      (setq smtpmail-smtp-user (nth 1 account)
            smtpmail-smtp-server (nth 2 account)
            smtpmail-smtp-service (nth 3 account))
      (message-remove-header "From")
      (message-add-header (format "From: %s" (nth 1 account))))))

(defun my-set-from-from-gnus-group ()
  "Définir automatiquement le From selon le groupe actif."
  (let ((group gnus-newsgroup-name))
    (cond
     ((string-match-p "nnimap\\+free:INBOX" group)
      (setq smtpmail-smtp-user "@free.fr"
            smtpmail-smtp-server "smtp.free.fr"
            smtpmail-smtp-service 587))
     ((string-match-p "nnimap\\+laposte:INBOX" group)
      (setq smtpmail-smtp-user "@laposte.net"
            smtpmail-smtp-server "smtp.laposte.net"
            smtpmail-smtp-service 587))
     ((string-match-p "nnimap\\+gmail:INBOX" group)
      (setq smtpmail-smtp-user "@gmail.com"
            smtpmail-smtp-server "smtp.gmail.com"
            smtpmail-smtp-service 587)))))

(add-hook 'message-setup-hook 'my-set-from-from-gnus-group)
(define-key message-mode-map (kbd "C-c C-f") 'my-choose-mail-account)

;; ---------------------------
;; Désactiver NNTP
;; ---------------------------
;(setq gnus-secondary-select-methods nil)

;; ---------------------------
;; Comptes IMAP
;; ---------------------------
(setq gnus-select-method
      '(nnimap "free"
               (nnimap-address "imap.free.fr")
               (nnimap-server-port 993)
               (nnimap-stream ssl)))

(setq gnus-secondary-select-methods
      '((nnimap "laposte"
                (nnimap-address "imap.laposte.net")
                (nnimap-server-port 993)
		
                (nnimap-stream ssl))
        (nnimap "gmail"
                (nnimap-address "imap.gmail.com")
                (nnimap-server-port 993)
                (nnimap-stream ssl))))

;; ;; ---------------------------
;; ;; Affichage
;; ;; ---------------------------
(setq gnus-fetch-old-headers t)

(setq gnus-save-newsrc t)
(setq gnus-read-newsrc-el t)
(setq gnus-use-cache t)
(setq gnus-keep-backlog 100)
(setq gnus-summary-display-arrow t)
(setq gnus-fetch-old-headers 'some)
(setq gnus-treat-display-smileys t)
(setq  gnus-permanently-visible-groups "\\(Travail\\|Sent\\|emploi\\)")

;; allow the html-renderer to display images
(setq gnus-blocked-images nil)
(setq gnus-blocked-images "ads")
;; prefer plain text over html when there's a choice
;; (setq mm-discouraged-alternatives '("text/html" "text/richtext"))
(setq mm-discouraged-alternatives nil)

;; Afficher le date, heure, sujet, mail dans la ligne de résumé
;; (setq gnus-summary-line-format
;;       "%U%R%z %(%&user-date;  %B: %S From:%F%)\n")

(setq gnus-summary-line-format
      (concat
       "%0{%U%R%z%}"            ;; flags
       "%3{│%}"                 ;; |
       "%3{%-20,30D%}"                ;; date (06-Jan) 1
       "%3{│%}"                 ;; | 3
       " " 
       ; "%3{%-20,30%&user-date;%}"    ;; heure HH:MM
        " " 
       "%3{│%}"                 ;; |
       "  "
       "%4{%-20,20f%}"          ;; expéditeur
       "  "
       "%3{│%}"                 ;; |
       " "
       "%1{%B%}"                ;; sujet (face)
       "%s\n"))



;; Désactiver l'archivage par défaut
(setq gnus-message-archive-group nil)

;; Utiliser une fonction pour router vers le bon dossier selon le compte
(setq gnus-message-archive-group
      (lambda (group)
        (when group
          (cond
           ;; Free.fr
           ((string-match "nnimap\\+free" group)
            "nnimap+free:Sent")
           ;; Laposte.net
           ((string-match "nnimap\\+laposte" group)
            "nnimap+laposte:INBOX/OUTBOX")
           ;; Gmail
           ((string-match "nnimap\\+gmail" group)
            "nnimap+gmail:[Gmail]/Sent Mail")
           ;; Par défaut : ne pas archiver
           (t nil)))))


(provide 'config-gnus)

;;; config-gnus.el ends here
