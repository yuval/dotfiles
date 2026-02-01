;;; init-osx-keys.el --- Configure keys specific to MacOS -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(when *is-a-mac*
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none)
  ;; Make mouse wheel / trackpad scrolling less jerky
  (setq mouse-wheel-scroll-amount '(1
                                    ((shift) . 5)
                                    ((control))))
  (dolist (multiple '("" "double-" "triple-"))
    (dolist (direction '("right" "left"))
      (global-set-key (read-kbd-macro (concat "<" multiple "wheel-" direction ">")) 'ignore)))
  (global-set-key (kbd "M-`") 'ns-next-frame)
  (global-set-key (kbd "M-h") 'ns-do-hide-emacs)
  (global-set-key (kbd "M-˙") 'ns-do-hide-others)
  (with-eval-after-load 'nxml-mode
    (define-key nxml-mode-map (kbd "M-h") nil))
  (global-set-key (kbd "M-ˍ") 'ns-do-hide-others) ;; what describe-key reports for cmd-option-h

  ;; Fast navigation with Command + arrow keys
  (global-set-key (kbd "M-<left>") 'backward-word)
  (global-set-key (kbd "M-<right>") 'forward-word)
  (global-set-key (kbd "M-<up>") 'backward-paragraph)
  (global-set-key (kbd "M-<down>") 'forward-paragraph)

  ;; Standard macOS copy/paste/save
  (global-set-key (kbd "M-c") 'kill-ring-save)  ; Cmd+C = copy
  (global-set-key (kbd "M-v") 'yank)            ; Cmd+V = paste
  (global-set-key (kbd "M-s") 'save-buffer)     ; Cmd+S = save

  ;; C-w = delete word backward, C-k = kill whole line
  (global-set-key (kbd "C-w") 'backward-kill-word)
  (global-set-key (kbd "C-k") 'kill-whole-line)
  )


(provide 'init-osx-keys)
;;; init-osx-keys.el ends here
