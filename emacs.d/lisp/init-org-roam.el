;;; init-org-roam.el --- Org-roam config -*- lexical-binding: t -*-
;;; Commentary:

;; Zettelkasten-style note-taking with org-roam.
;; Notes are stored in ~/org-roam/.

;;; Code:

(when (maybe-require-package 'org-roam)
  (setq org-roam-directory (file-truename "~/org-roam/"))

  (with-eval-after-load 'org-roam
    (org-roam-db-autosync-mode))

  (global-set-key (kbd "C-c n f") 'org-roam-node-find)
  (global-set-key (kbd "C-c n i") 'org-roam-node-insert)
  (global-set-key (kbd "C-c n l") 'org-roam-buffer-toggle)
  (global-set-key (kbd "C-c n c") 'org-roam-capture))

(provide 'init-org-roam)
;;; init-org-roam.el ends here
