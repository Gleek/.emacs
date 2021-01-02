
(use-package apache-mode :ensure t)
(use-package csv-mode :ensure t)


(use-package abbrev
  :ensure nil
  :diminish "🆎")



(use-package dap-mode)
(use-package lua-mode)
(use-package dockerfile-mode)
(use-package docker-compose-mode)
(use-package terraform-mode
  :ensure terraform-mode
  :ensure company-terraform)

(use-package json-mode
  :bind (:map json-mode-map
              (("C-c C-f" . json-pretty-print)
               ("C-c C-d" . nil))))
(use-package counsel-jq
  :after json-mode
  :bind (:map json-mode-map ("C-c C-s" . counsel-jq)))
(use-package less-css-mode)
(use-package rainbow-mode :diminish "🌈")


(use-package rust-mode
  :init
  (setq rust-format-on-save t)
  :config
  (flycheck-mode -1))

(use-package robe
  :ensure t
  :config
  (defadvice inf-ruby-console-auto (before activate-rvm-for-robe activate)
    (rvm-activate-corresponding-ruby))
  (add-hook 'ruby-mode-hook 'robe-mode)
  (eval-after-load 'company
    '(push 'company-robe company-backends)))


(use-package makefile-executor
  :hook (makefile-mode . makefile-executor-mode)
  :bind (("C-c p m". makefile-executor-execute-project-target)
         (:map makefile-executor-mode-map
               ("C-c C-d" . nil))))

(use-package makefile-mode
  :ensure nil
  :bind (:map makefile-mode-map
              ("M-p" . nil)))

(provide 'core-misc)
