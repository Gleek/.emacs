;;; keybindings.el --- Emacs keybindings.
;;
;;; Commentary:
;; Keybindings used in Emacs

;;; Code:
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
;; (global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-s") 'isearch-forward)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "C-c e") 'eval-and-replace)
(global-set-key (kbd "C-x m") 'magit-status)
;; (global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-x") 'helm-M-x)
;; (global-set-key (kbd "M-p") 'helm-projectile)
(global-set-key (kbd "M-p") 'projectile-find-file)
(global-set-key (kbd "C-c g") 'helm-google-suggest)
(global-set-key (kbd "C-c a") 'helm-do-ag)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "M-;") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-a") 'beginning-of-line-or-indentation)
(global-set-key (kbd "C-x a r") 'align-regexp)
(add-hook 'LaTeX-mode-hook
          (lambda nil
            (local-set-key (kbd "C-c C-t x") 'TeX-toggle-escape)))
(global-set-key (kbd "C-c n") 'cleanup-buffer)
(global-set-key (kbd "M-z") 'zop-to-char)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-$")'mc/mark-more-like-this-extended)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c m") 'mc/mark-all-like-this)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-\"") 'avy-goto-word-or-subword-1)
(global-set-key (kbd "C-'") 'avy-goto-char-timer)
(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)
(global-set-key (kbd "C-c r")  'rename-file-and-buffer)
(global-set-key (kbd "C-x C-r") 'sudo-edit)
(global-set-key (kbd "C-x 2") 'vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'hsplit-last-buffer)
(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)
(global-set-key (kbd "C-c C-d") 'duplicate-and-comment-current-line-or-region)
(global-set-key (kbd "C-^") 'top-join-line)
(global-set-key (kbd "C-c C-F") 'fold-this-all)
(global-set-key (kbd "C-c C-f") 'fold-this)
(global-set-key (kbd "C-c M-f") 'fold-this-unfold-all)
(global-unset-key (kbd "M-."))

(eval-after-load "php-mode"
  '(progn
     (local-unset-key (kbd "C-c C-f"))))

(eval-after-load "helm-gtags"
  '(progn
     ;; (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
     ;; (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
     ;; (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
     ;; (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
     ;; (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
     ;; (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
     (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-find-rtag)
     (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-find-tag-from-here)))
;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(global-set-key (kbd "<escape>") 'god-local-mode)
(global-set-key [remap kill-whole-line] 'smart-kill-whole-line)
(global-set-key [(shift return)] 'smart-open-line)
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(provide 'keybindings)
;;; keybindings.el ends here
