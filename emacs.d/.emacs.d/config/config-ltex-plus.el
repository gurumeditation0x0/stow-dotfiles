(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((text-mode . lsp-deferred)
         (markdown-mode . lsp-deferred)
         (org-mode . lsp-deferred)
         (latex-mode . lsp-deferred))
  :custom
  (lsp-signature-auto-activate t))

(setq lsp-auto-guess-root t)

(use-package lsp-ltex-plus
  :ensure t
  :after lsp-mode
  :custom
  (lsp-ltex-plus-java-path
   "/home/alain/dev/ltex-ls-plus-18.7.0/jdk-21.0.10+7")
  (lsp-ltex-plus-language "fr")
  (lsp-ltex-plus-disabled-rules '("WHITESPACE_RULE"))
  (lsp-ltex-plus-completion-enabled t))

