;;; init-markdown.el --- Markdown support -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when (maybe-require-package 'markdown-mode)
  (add-auto-mode 'markdown-mode "\\.md\\.html\\'")
  (with-eval-after-load 'whitespace-cleanup-mode
    (add-to-list 'whitespace-cleanup-mode-ignore-modes 'markdown-mode))
  (with-eval-after-load 'markdown-mode
    ;; Use global paragraph navigation instead of markdown-specific
    (define-key markdown-mode-map (kbd "M-<up>") nil)
    (define-key markdown-mode-map (kbd "M-<down>") nil)))


(provide 'init-markdown)
;;; init-markdown.el ends here
