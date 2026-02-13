(use-package biome
  :ensure t
  :config
  (setq biome-grid-date-format "%d-%m-%Y")
  (setq biome-grid-datetime-format "%H:%M %d-%m-%Y")
  (setq biome-query-override-column-names
	'(("" ."")
	  ("sunrise" . "Lever")
	  ("sunset" . "Coucher")
	  ("temperature_2m_min" . "Min")
	  ("temperature_2m_max" . "Max")
	  ("temperature_2m" . "Temp")
	  ("relativehumidity_2m" . "Humidité")
	  ("rain" . "Pluie")
	  ("weathercode" . "Tendance")
	  ("surface_pressure" . " ")
	  ("cloudcover" . "Nuages")
	  ("showers" . "Averses")
	  ("windspeed_10m" . "Vents")
	  ("snowfall" . "Neige")
	  ("rain-sum" . "Pluie")
	  ("precipitation_probability_max" . "Pluie")
	  ("winddirection_10m_dominant" . "Vents")
	  ("windspeed_10m_max" . "Max")
	  ("rain_sum" . "Pluie"))))

;; (add-hook 'biome-grid-mode-hook
;; ;;          (lambda ()
;; ;;            (when (derived-mode-p 'biome-grid-mode-hook)
;;               (lin-enable-mode-in-buffers))q;;))

(biome-def-preset biome-query-preset-jour
  ((:name . "Weather Forecast")
   (:group . "hourly")
   (:params
    ("temperature_unit" . "celsius")
    ("windspeed_unit" . "kmh")
    ("precipitation_unit" . "mm")
    ("timezone" . "Europe/Paris")
    ("elevation" . 150)
    ("hourly" "snowfall" "cloudcover"  "showers" "rain" "surface_pressure" "windspeed_10m" "relativehumidity_2m" "temperature_2m" "weathercode" )
    ("longitude" . 7.75211)
    ("latitude" . 48.573405))))

(biome-def-preset biome-query-preset-semaine
  ((:name . "Weather Forecast")
   (:group . "daily")
   (:params
    ("temperature_unit" . "celsius")
    ("windspeed_unit" . "kmh")
    ("precipitation_unit" . "mm")
    ("forecast_days" . 7)
    ("timezone" . "Europe/Paris")
    ("elevation" . 150)
    ("daily" "windspeed_10m_max" "winddirection_10m_dominant" "precipitation_probability_max" "rain_sum" "sunset" "sunrise" "temperature_2m_min" "temperature_2m_max" "weathercode")
    ("longitude" . 7.75211)
    ("latitude" . 48.573405))))

;; météo du jour heure par heure
;; (defalias 'jmeteo
;;   (kmacro "M-x biome-query-preset-jour <return> <return>"))

;; ;; météo 7 prochains jours
;; (defalias 'smeteo
;;   (kmacro "M-x biome-query-preset-semaine <return> <return>"))
