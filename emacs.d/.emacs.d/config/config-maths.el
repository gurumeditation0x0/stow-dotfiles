
;;; config-maths.el --- Configuration maths (Maxima, Octave, Gnuplot) -*- lexical-binding: t; -*-

;;; Commentary:
;; Configuration minimale et propre pour utiliser Org-babel
;; avec Maxima, Octave et Gnuplot dans Emacs.
;;
;; Objectif :
;; - léger
;; - modulaire
;; - sans conflit avec d'autres configs

;;; Code:


;;       Doublons avec config-org-babel
;; (with-eval-after-load 'org
;;
;;    Activer les langages sans écraser les autres
;;   
;;    (dolist (lang '((maxima . t)
;;                    (octave . t)
;;                    (gnuplot . t)))
;;      (add-to-list 'org-babel-load-languages lang))
;;
;;   ;; Charger les langages
;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    org-babel-load-languages)

  ;; Ne pas demander confirmation à chaque exécution
  (setq org-confirm-babel-evaluate nil)

  ;; Meilleur affichage du code
  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)

  ;; Afficher les images inline (utile pour gnuplot)
  (setq org-startup-with-inline-images t)

  ;; Rafraîchir automatiquement les images après exécution
  (add-hook 'org-babel-after-execute-hook
            #'org-display-inline-images)

  ;; Optionnel : indentation plus propre dans les blocs
  (setq org-edit-src-content-indentation 0)

  ;; Messages debug (tu peux commenter si inutile)
  (message "[config-maths] Org-babel maths chargé avec : %S"
           org-babel-load-languages)
)

(provide 'config-maths)

;;; config-maths.el ends here
