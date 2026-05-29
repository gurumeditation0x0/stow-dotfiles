;;; config-org-babel.el --- Org Babel languages -*- lexical-binding: t; -*-

(use-package gnuplot)


(with-eval-after-load 'org

  ;; Activer les langages
  (dolist (lang '(
                  ;; général
                  (emacs-lisp . t)
		  (lisp . t)
                  (shell . t)
		  (python . t)
                  ;; maths
                  (maxima . t)
                  (octave . t)
                  (gnuplot . t)
                  ;; graphes
                  (dot . t)
                  ;;(mermaid . t)
                  ))
    (add-to-list 'org-babel-load-languages lang))

  ;; Chargement effectif
  (org-babel-do-load-languages
   'org-babel-load-languages
   org-babel-load-languages)

  ;; IMPORTANT : corrige ton problème Maxima + résultats vides
  (setq org-babel-maxima-command "maxima")

  (setq org-babel-default-header-args:maxima
        '((:results . "output")
          (:session . "none")))

  (setq org-confirm-babel-evaluate nil)
 
;; Images auto-refresh après exécution Babel
(add-hook 'org-babel-after-execute-hook #'org-display-inline-images)

  (message "[org-babel] loaded languages: %S"
           org-babel-load-languages))

(provide 'config-org-babel)
