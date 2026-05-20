;;; config-org-babel.el --- Org Babel languages -*- lexical-binding: t; -*-


(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 4)
  (setq font-lock-maximum-decoration t)
  :hook
  (graphviz-dot-mode . flycheck-mode))

(use-package maxima)
;;(use-package matlab-mode)


(with-eval-after-load 'org

    ;; mapping coloration
  (add-to-list 'org-src-lang-modes '("dot" . graphviz-dot))
  (add-to-list 'org-src-lang-modes '("octave" . matlab))
  (add-to-list 'org-src-lang-modes '("maxima" . maxima))
  (add-to-list 'org-src-lang-modes '("python" . python))

  ;; Activer les langages UNE SEULE FOIS (sans écraser)
  (dolist (lang '(
                  ;; général
                  (emacs-lisp . t)
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

  ;; sécurité
  (setq org-confirm-babel-evaluate nil)

  (message "[org-babel] loaded languages: %S"
           org-babel-load-languages))

(provide 'config-org-babel)
