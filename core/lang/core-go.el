;;  go get -u golang.org/x/tools/gopls
;;  go get -u github.com/fatih/gomodifytags
;;  go get github.com/go-delve/delve/cmd/dlv
;;  go get -v github.com/rogpeppe/godef
;;  go get -u github.com/motemen/gore/cmd/gore
;;  DEPRECATED: go get -u github.com/stamblerre/gocode
;;  go get -u golang.org/x/tools/cmd/godoc
;;  go get -u golang.org/x/tools/cmd/goimports
;;  go get -u golang.org/x/tools/cmd/gorename
;;  DEPRECATED: go get -u golang.org/x/tools/cmd/guru
;;
;;
;; https://golangci-lint.run/usage/install/#local-installation
;; brew install golangci-lint
;; curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.31.0

;;; Code:

(use-package go-mode
  :ensure go-mode
  :ensure go-tag
  :ensure go-gen-test
  :ensure flycheck-golangci-lint
  :bind (:map go-mode-map
              ("C-c a" . +go-tag-add)
              ("C-c C-d" . nil))
  :config
  (require 'dap-go)
  (dap-go-setup)
  (setq flycheck-golangci-lint-enable-linters '("dupl" "gocritic" "gocognit" "gomnd" "maligned" "lll" "unparam"))

  (defun +go-tag-add(arg)
    (interactive "P")
    (if (eq arg nil)
        (let ((go-tag-args '("-transform" "camelcase")))
          (call-interactively 'go-tag-add))
      (let ((go-tag-args nil))
        (call-interactively 'go-tag-add))))

  (defun +go-setup-checkers()
    (flycheck-golangci-lint-setup)

    ;; Demote golangci errors to info
    (dolist (patt (get 'golangci-lint 'flycheck-error-patterns))
      (setcdr patt 'warning))
    (setq flycheck-local-checkers '((lsp . ((next-checkers . ((warning . golangci-lint))))))))

  ;; (setq dap-go-debug-program `("node" ,(concat dap-go-debug-path "/extension/dist/debugAdapter.js")))
  (setq gofmt-command "goimports")
  ;; (add-hook 'go-mode-hook #'go-eldoc-setup)
  (add-hook 'before-save-hook 'gofmt-before-save)

  (add-hook 'go-mode-hook #'+go-setup-checkers)
  
  (set-popup-rule! "^\\*go-guru-output\\*" :size 0.4 :quit t))

(use-package gorepl-mode
  :bind (:map gorepl-mode-map
              ("C-c C-g" . nil))
  :config
  (add-hook 'go-mode-hook #'gorepl-mode))

(use-package go-playground
  :init
  (setq go-playground-basedir (expand-file-name "src/example.com/playground/" (getenv "GOPATH"))))

(provide 'core-go)
