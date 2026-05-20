;;; config-org-babel.el --- Org Babel languages -*- lexical-binding: t; -*-

(with-eval-after-load 'org

  ;; Activer les langages UNE SEULE FOIS (sans écraser)
  (dolist (lang '(
                  ;; général
                  (emacs-lisp . t)
                  (shell . t)

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

  ;; sécurité
  (setq org-confirm-babel-evaluate nil)

  (message "[org-babel] loaded languages: %S"
           org-babel-load-languages))

(provide 'config-org-babel)
