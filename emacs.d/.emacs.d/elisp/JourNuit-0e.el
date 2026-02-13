;;; ---------------------------
;;; Journuit : thème clair / sombre selon lever / coucher du soleil
;;; ---------------------------

(require 'calendar)
(require 'solar)

;; Localisation
(setq calendar-latitude 48.584667)
(setq calendar-longitude 7.736424)
(setq calendar-location-name "Strasbourg, FR")

(defvar journuit-timer nil)

;; --------------------------------------------------
;; Lever / coucher du soleil pour une date donnée
;; --------------------------------------------------

(defun extract-sunset-sunrise-times (&optional date)
  "Extrait les heures de lever et de coucher du soleil pour DATE.
DATE : (month day year), sinon aujourd'hui.
Retourne (sunrise sunset) en heures décimales."
  (unless date
    (setq date (calendar-current-date)))
  (let* ((rise-set (solar-sunrise-sunset date))
         (sunrise (car rise-set))
         (sunset (cadr rise-set)))
    (list (if (listp sunrise) (car sunrise) sunrise)
          (if (listp sunset) (car sunset) sunset))))

(defun decimal-to-hm (decimal)
  "Convertit une heure décimale en HH:MM."
  (let* ((hours (floor decimal))
         (minutes (floor (* 60 (- decimal hours)))))
    (format "%02d:%02d" hours minutes)))

;; --------------------------------------------------
;; Date de demain (robuste fin de mois / année)
;; --------------------------------------------------

(defun journuit-tomorrow (date)
  "Retourne la date du lendemain à partir de DATE (month day year)."
  (calendar-gregorian-from-absolute
   (1+ (calendar-absolute-from-gregorian date))))

;; --------------------------------------------------
;; Décision centrale
;; --------------------------------------------------

(defun journuit-decide ()
  "Décide le thème à charger et le prochain événement.
Retourne (THEME NEXT-TIME NEXT-DATE)."
  (let* ((today (calendar-current-date))
         (now (decode-time))
         (heure (+ (nth 2 now) (/ (nth 1 now) 60.0)))
         (today-times (extract-sunset-sunrise-times today))
         (sunrise (car today-times))
         (sunset (cadr today-times)))
    (cond
     ;; Avant le lever → sombre, lever aujourd'hui
     ((< heure sunrise)
      (list 'dark sunrise today))
     ;; Entre lever et coucher → clair, coucher aujourd'hui
     ((< heure sunset)
      (list 'light sunset today))
     ;; Après le coucher → sombre, lever demain
     (t
      (let* ((tomorrow (journuit-tomorrow today))
             (tomorrow-times (extract-sunset-sunrise-times tomorrow)))
        (list 'dark (car tomorrow-times) tomorrow))))))

;; --------------------------------------------------
;; Conversion heure décimale + date → temps absolu
;; --------------------------------------------------

(defun journuit-absolute-time (decimal date)
  (let* ((h (floor decimal))
         (m (floor (* 60 (- decimal h)))))
    (encode-time 0 m h
                 (cadr date) (car date) (nth 2 date))))

;; --------------------------------------------------
;; Application du thème + programmation suivante
;; --------------------------------------------------

(defun journuit-apply-and-schedule ()
  (when journuit-timer
    (cancel-timer journuit-timer))

 
(target-theme (if (eq theme 'dark)
                  'ef-elea-dark
                'ef-elea-light)))

;; Charger le thème seulement s’il est différent
(unless (member target-theme custom-enabled-themes)
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme target-theme t))
    
    ;; Programmer le prochain changement
    (setq journuit-timer
          (run-at-time
           (journuit-absolute-time next-time next-date)
           nil
           #'journuit-apply-and-schedule))

    ;; Messages visibles
    (message "🕒 [journuit] Heure actuelle : %s" now-hm)
    (message "🌗 [journuit] Thème %s → prochain changement le %s à %s"
             (if (eq theme 'dark) "SOMBRE 🌙" "CLAIR ☀️")
             date-str
             next-hm)))

;; --------------------------------------------------
;; Initialisation
;; --------------------------------------------------

(defun journuit-init ()
  (journuit-apply-and-schedule))

(journuit-init)
