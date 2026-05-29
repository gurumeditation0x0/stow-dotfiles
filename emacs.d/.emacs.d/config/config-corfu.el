(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                 ; Allows cycling through candidates
  (corfu-auto t)                  ; Enable auto completion
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.3)
  (corfu-popupinfo-delay '(0.5 . 0.2))
  (corfu-preview-current 'insert) ; Do not preview current candidate
  (corfu-preselect 'prompt)
  (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets

  :bind (:map corfu-map
            ("M-SPC"      . corfu-insert-separator)
            ("TAB"        . corfu-complete)
            ([tab]        . corfu-complete)
            ("S-TAB"      . corfu-previous)
            ([backtab]    . corfu-previous)
            ("S-<return>" . corfu-insert)
            ("RET"        . corfu-quit))
  :init
  (global-corfu-mode)
  (corfu-history-mode)
  (corfu-popupinfo-mode) ; Popup completion info
  :config
  (add-hook 'eshell-mode-hook
            (lambda () (setq-local corfu-quit-at-boundary t
                              corfu-quit-no-match t
                              corfu-auto nil)
              (corfu-mode)))) 

;; cape : completion supplémentaire pour corfu
(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))
