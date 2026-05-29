;;; config-python.el --- Python scientific setup -*- lexical-binding: t; -*-

;; Python dans Org Babel
;; (with-eval-after-load 'org

;;   (add-to-list 'org-babel-load-languages '(python . t))
;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    org-babel-load-languages)

  ;; affichage propre des résultats Python
  (setq org-babel-python-command "python3")

  ;; résultats plus lisibles dans les .org avec Yasnippets
  ;; (setq org-babel-default-header-args:python
  ;;       '((:results . "output")
  ;;         (:session . "none")
  ;;         (:exports . "both")))

  (message "[python] Org Babel ready")

;; Optionnel : indentation propre
(setq python-indent-offset 4)

(provide 'config-python)
