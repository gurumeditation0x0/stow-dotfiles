
(setq calendar-time-display-form
      '(24-hours "." minutes
        (if time-zone " (") time-zone (if time-zone ")")))

(setq calendar-latitude 48.584667)
(setq calendar-longitude 7.736424)
(setq calendar-location-name "Strasbourg, FR")

(defvar sunset-time nil)
(defvar sunrise-time nil)
(defvar heure nil)

(defun  day-or-night()
  "Fonction qui jcharge un thème sombre ou clair en fonction de l'heure"
  (interactive)
  (extract-sunset-sunrise-times)
  (message "message depuis journuit sunset-time %s" sunset-time)
;;  (setq sunset-time (string-to-number sunset-time))
;;  (setq sunrise-time (string-to-number sunrise-time))
  (let* ((sunset-time (string-to-number sunset-time))
	 (sunrise-time (string-to-number sunrise-time))
	 (heure (string-to-number (format-time-string "%H.%M" (current-time)))))
    (message "heure actuelle: %s" heure)
    (if (or (>= heure sunset-time) (< heure sunrise-time))
        (load-theme 'ef-elea-dark t)
      (load-theme 'ef-elea-light t))))

(defun set-timer-day-night ()
  (interactive)
    (cancel-function-timers 'journuit)
    (run-at-time (replace-regexp-in-string "\\." ":" sunset-time) nil 'journuit)
    (run-at-time (replace-regexp-in-string "\\." ":" sunrise-time) nil 'journuit)
)

(defun extract-sunset-sunrise-times ()
  "Extrait les heures de lever et de coucher du soleil à partir du résultat de (sunset-sunrise)."
  (interactive)
  (let* ((sunset-sunrise-string (sunrise-sunset))
         (regex "\\([0-9]+\\.[0-9]+\\).*?\\([0-9]+\\.[0-9]+\\)"))
    (when (string-match regex sunset-sunrise-string)
      (setq sunrise-time (match-string 1 sunset-sunrise-string))
      (setq sunset-time (match-string 2 sunset-sunrise-string))
      (message "Sunrise-_-time: %s, Sunset-_-time: %s" sunrise-time sunset-time)
      )))

(day-or-night)


;; (defun journuit ()
;;   (progn
;;     (day-or-night)
;;     (set-timer-day-night)))
;; (journuit)

;; (journuit)
;;(set-timer-jn)
;; (run-at-time (replace-regexp-in-string "\\." ":" sunset-time) nil 'journuit)
;; (run-at-time (replace-regexp-in-string "\\." ":" sunrise-time) nil 'journuit)

;; (run-at-time "01:03" nil 'journuit)

