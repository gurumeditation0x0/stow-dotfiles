
;;; timestamp-messages.el --- Add timestamps to *Messages* buffer -*- lexical-binding: t; -*-

(defvar my-package--last-message nil
  "Last message with timestamp appended to it.")

(defun my-package-ad-timestamp-message (format-string &rest args)
  "Prepend timestamp to each message in message buffer.
Ne met pas de timestamp sur les messages répétés."
  (when (and message-log-max
             (not (string-equal format-string "%s%s")))
    (let ((formatted-message-string (if args
                                        (apply 'format `(,format-string ,@args))
                                      format-string)))
      (unless (string= formatted-message-string my-package--last-message)
        (setq my-package--last-message formatted-message-string)
        (let ((deactivate-mark nil)
              (inhibit-read-only t))
          (with-current-buffer "*Messages*"
            (goto-char (point-max))
            (when (not (bolp))
              (newline))
            (insert (format-time-string "[%F %T.%3N] "))))))))

(advice-add 'message :before 'my-package-ad-timestamp-message)

(provide 'timestamp-messages)
