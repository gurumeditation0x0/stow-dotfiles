;;; journuit.el --- Thème clair/sombre automatique selon lever/coucher -*- lexical-binding: t; -*-

;; Author: Votre Nom
;; Version: 0.2
;; Package-Requires: ((emacs "27.1"))
;; Keywords: themes, convenience
;;
;; Description:
;; Charge automatiquement un thème clair ou sombre selon
;; le lever et le coucher du soleil, basé sur `solar.el`.
;;
;; Configuration entièrement via M-x customize-group RET journuit
;;
;; Fonctionne sous Windows et GNU/Linux.
;;
;; Nécessite seulement :
;;   (require 'journuit)
;;   (journuit-init)

;;; Code:

(require 'calendar)
(require 'solar)

;; ==================================================
;; Groupe Customize
;; ==================================================

(defgroup journuit nil
  "Changement automatique de thème jour/nuit."
  :group 'appearance)

;; ==================================================
;; Thèmes configurables
;; ==================================================

(defcustom journuit-dark-theme 'ef-elea-dark
  "Thème chargé durant la nuit."
  :type 'symbol
  :group 'journuit)

(defcustom journuit-light-theme 'ef-elea-light
  "Thème chargé durant le jour."
  :type 'symbol
  :group 'journuit)

;; ==================================================
;; Localisation configurables
;; ==================================================

(defcustom journuit-latitude 48.584667
  "Latitude utilisée pour le calcul solaire."
  :type 'number
  :group 'journuit)

(defcustom journuit-longitude 7.736424
  "Longitude utilisée pour le calcul solaire."
  :type 'number
  :group 'journuit)

(defcustom journuit-location-name "Strasbourg, FR"
  "Nom descriptif de la localisation."
  :type 'string
  :group 'journuit)

;; ==================================================
;; Variables internes
;; ==================================================

(defvar journuit-timer nil
  "Timer interne pour le prochain changement automatique.")

;; ==================================================
;; Synchronisation localisation avec calendar/solar
;; ==================================================

(defun journuit--apply-location ()
  "Applique les coordonnées configurées à calendar/solar."
  (setq calendar-latitude journuit-latitude
        calendar-longitude journuit-longitude
        calendar-location-name journuit-location-name))

;; ==================================================
;; Calcul lever / coucher soleil
;; ==================================================

(defun journuit--sun-times (&optional date)
  "Retourne (sunrise sunset) en heures décimales pour DATE.
DATE est au format (month day year)."
  (journuit--apply-location)
  (unless date
    (setq date (calendar-current-date)))
  (let* ((rise-set (solar-sunrise-sunset date))
         (sunrise (car rise-set))
         (sunset (cadr rise-set)))
    (list (if (listp sunrise) (car sunrise) sunrise)
          (if (listp sunset) (car sunset) sunset))))

(defun journuit--decimal-to-hm (decimal)
  "Convertit une heure décimale en chaîne HH:MM."
  (let* ((hours (floor decimal))
         (minutes (floor (* 60 (- decimal hours)))))
    (format "%02d:%02d" hours minutes)))

(defun journuit--tomorrow (date)
  "Retourne la date du lendemain à partir de DATE."
  (calendar-gregorian-from-absolute
   (1+ (calendar-absolute-from-gregorian date))))

;; (defun journuit--absolute-time (decimal date)
;;   "Convertit DECIMAL + DATE en temps absolu."
;;   (let* ((h (floor decimal))
;;          (m (floor (* 60 (- decimal h)))))
;;     (encode-time 0 m h
;;                  (cadr date) (car date) (nth 2 date))))

(defun journuit--absolute-time (decimal date)
  "Convertit DECIMAL + DATE en temps absolu."
  (let* ((h (floor decimal))
         (remainder (- decimal h))	; heure
         (m (floor (* 60 remainder)))	; minutes
         (s (floor (* 60 (- (* 60 remainder) m)))))	; secondes
    (encode-time
     (list s                    ; seconds
           m                    ; minutes
           h                    ; hours
           (cadr date)          ; day
           (car date)           ; month
           (nth 2 date)))))     ; year

;; ==================================================
;; Décision centrale
;; ==================================================

(defun journuit--decide ()
  "Détermine le thème à charger.
Retourne (THEME NEXT-TIME NEXT-DATE)."
  (let* ((today (calendar-current-date))
         (now (decode-time))
         (heure (+ (nth 2 now) (/ (nth 1 now) 60.0)))
         (today-times (journuit--sun-times today))
         (sunrise (car today-times))
         (sunset (cadr today-times)))
    (cond
     ;; Avant lever → sombre
     ((< heure sunrise)
      (list 'dark sunrise today))
     ;; Entre lever et coucher → clair
     ((< heure sunset)
      (list 'light sunset today))
     ;; Après coucher → sombre jusqu’au lever demain
     (t
      (let* ((tomorrow (journuit--tomorrow today))
             (tomorrow-times (journuit--sun-times tomorrow)))
        (list 'dark (car tomorrow-times) tomorrow))))))

;; ==================================================
;; Application + planification
;; ==================================================

(defun journuit-apply-and-schedule ()
  "Applique le thème approprié et programme le prochain changement."
  (interactive)

  ;; Annule timer précédent si existant
  (when journuit-timer
    (cancel-timer journuit-timer))

  (pcase-let* ((`(,theme ,next-time ,next-date)
                (journuit--decide))
               (target-theme
                (if (eq theme 'dark)
                    journuit-dark-theme
                  journuit-light-theme))
               (next-hm (journuit--decimal-to-hm next-time)))

    ;; Vérifie que le thème existe
    (unless (member target-theme (custom-available-themes))
      (error "[journuit] Thème %s non disponible" target-theme))

    ;; Désactive thèmes actifs
    (mapc #'disable-theme custom-enabled-themes)

    ;; Charge thème
    (load-theme target-theme t)

    ;; Programme prochain changement
    (setq journuit-timer
          (run-at-time
           (journuit--absolute-time next-time next-date)
           nil
           #'journuit-apply-and-schedule))

    (message "[journuit] %s chargé. Prochain changement à %s (%s)"
             target-theme
             next-hm
             journuit-location-name)))

;; ==================================================
;; Initialisation
;; ==================================================

(defun journuit-init ()
  "Initialise journuit et démarre le système automatique."
  (interactive)
  (journuit-apply-and-schedule))

(provide 'journuit)

;;; journuit.el ends here
