(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)

  ;; dossier de snippets perso
  (setq yas-snippet-dirs
        '("~/.emacs.d/yasnippets"))

  (yas-reload-all))

(message "[Snippets] YASnippet chargé")
