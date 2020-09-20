;; Org mode settings
(defvar +org-directory "~/Dropbox/org-files/")


(use-package org-crypt
  :ensure nil
  :defer 5
  :init
  (setq org-tags-exclude-from-inheritance (quote ("crypt")))
  (setf epg-pinentry-mode 'loopback)
  (setq org-crypt-key nil)
  ;; GPG key to use for encryption
  ;; Either the Key ID or set to nil to use symmetric encryption.
  :config (org-crypt-use-before-save-magic))

;; To turn it off auto-save only locally, you can insert this:
;; # -*- buffer-auto-save-file-name: nil; -*-

;; (use-package org-bullets
;;   :init (remove-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; (use-package org-wunderlist
;;   :init (setq org-wunderlist-file  "~/.emacs.d/Wunderlist.org"
;;                 org-wunderlist-dir "~/.emacs.d/org-wunderlist/"))


(use-package org-pomodoro
  :config
  (setq org-pomodoro-finished-sound "~/.emacs.d/resources/doorbell.wav")
  (setq org-pomodoro-long-break-sound "~/.emacs.d/resources/doorbell.wav")
  (setq org-pomodoro-short-break-sound "~/.emacs.d/resources/doorbell.wav")
  (setq org-pomodoro-start-sound "~/.emacs.d/resources/doorbell.wav"))

(use-package org
  :config
  (defvar org-plantuml-jar-path)
  ;; helper function
  (defun my-org-confirm-babel-evaluate (lang body)
    "Do not ask for confirmation to evaluate code for specified languages."
    (member lang '("plantuml")))

  (defun variable-pitch-for-notes ()
    (when (string-match "\\(.*Notes.org\\|roam.*org\\)" (format "%s" buffer-file-name))
      (progn
        (setq cursor-type 'bar)
        (variable-pitch-mode t))))


  (defun +capture-inbox()
    (interactive)
    (org-capture nil "i"))
  ;; trust certain code as being safe

  (setq org-capture-templates
        `(("i" "inbox" entry (file ,(concat +org-directory "inbox.org"))
           "* TODO %?")
          ("l" "link" entry (file ,(concat +org-directory "inbox.org"))
           "* TODO %(org-cliplink-capture)" :immediate-finish t)
          ("c" "org-protocol-capture" entry (file ,(concat +org-directory "inbox.org"))
           "* TODO [[%:link][%:description]]\n\n %i" :immediate-finish t)))

  (setq org-ellipsis "…"
        org-agenda-files `(,+org-directory)
        org-archive-location (concat +org-directory "archive.org::* From %s")
        org-startup-align-all-table t
        org-log-done 'time
        org-startup-with-inline-images t
        org-display-remote-inline-images 'download
        org-hide-emphasis-markers t
        org-hide-leading-stars t
        org-id-locations-file (concat CACHE-DIR ".org-id-locations")
        org-image-actual-width 500
        org-imenu-depth 8
        org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+") ("1." . "a."))
        org-html-checkbox-type 'html
        org-priority-faces
        '((?A . error)
          (?B . warning)
          (?C . success))
        org-startup-indented t
        org-id-link-to-org-use-id t
        org-todo-keywords '((sequence "TODO(t)" "DOING(o)"  "|" "DONE(d)")
                            (sequence "BLOCKED(b@/!)" "DELEGATED(e@/!)" "WAITING(w@/!)" "|" "CANCELLED(c@/!)"))
        org-treat-S-cursor-todo-selection-as-state-change nil
        org-fontify-whole-heading-line t
        org-fontify-done-headline t
        org-fontify-quote-and-verse-blocks t
        org-confirm-babel-evaluate nil
        org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %16TIMESTAMP_IA")

  (setq help-at-pt-display-when-idle t)

  (setq org-refile-targets
        '((nil :maxlevel . 8)
          (org-agenda-files :maxlevel . 8))
        ;; Without this, completers like ivy/helm are only given the first level of
        ;; each outline candidates. i.e. all the candidates under the "Tasks" heading
        ;; are just "Tasks/". This is unhelpful. We want the full path to each refile
        ;; target! e.g. FILE/Tasks/heading/subheading
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil)

  (setq org-src-preserve-indentation t  ; use native major-mode indentation
        org-src-tab-acts-natively t     ; we do this ourselves
        org-link-elisp-confirm-function nil
        ;; Show src buffer in popup, and don't monopolize the frame
        org-src-window-setup 'other-window)

  (defadvice org-edit-src-exit (after restore-window-config activate)
    (winner-undo))

  (setq org-display-remote-inline-images 'download) ; TRAMP urls
  (org-link-set-parameters "http"  :image-data-fun #'+org-http-image-data-fn)
  (org-link-set-parameters "https" :image-data-fun #'+org-http-image-data-fn)
  (org-link-set-parameters "img"   :image-data-fun #'+org-inline-image-data-fn)

  ;; (font-lock-remove-keywords 'org-mode
  ;;                       '(("^ *\\((-)\\) "
  ;;                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  (add-hook 'org-mode-hook 'visual-line-mode)
  ;; (add-hook 'org-mode-hook 'toggle-truncate-lines)
  (company-backend-for-hook 'org-mode-hook '((company-org-roam company-yasnippet company-dabbrev)))
  (add-hook 'org-mode-hook 'variable-pitch-for-notes)
  (add-hook 'org-mode-hook (lambda() (setq line-spacing 0.1)))
  (add-hook 'org-mode-hook (lambda() (display-line-numbers-mode -1)))
  (add-hook 'org-mode-hook (lambda ()
                             (progn
                               (setq left-margin-width 5)
                               (setq right-margin-width 5))))

  (setq org-modules
        '(;; ol-w3m
          ;; ol-bbdb
          ol-bibtex
          ;; ol-docview
          ;; ol-gnus
          ;; ol-info
          ;; ol-irc
          ;; ol-mhe
          ;; ol-rmail
          ;; ol-eww
          org-habit
          ))
  ;; Save target buffer after archiving a node.
  ;; (setq org-archive-subtree-save-file-p t)

  ;; Prevent modifications made in invisible sections of an org document, as
  ;; unintended changes can easily go unseen otherwise.
  (setq org-catch-invisible-edits 'smart)

  (custom-set-faces
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))
  :config
  ;; Support for plantuml
  (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))
  (add-to-list
   'org-src-lang-modes '("plantuml" . plantuml))


  (advice-add #'org-babel-execute:plantuml
              :override #'+plantuml-org-babel-execute:plantuml-a)
  (add-to-list 'org-babel-default-header-args:plantuml
               '(:cmdline . "-charset utf-8"))

  ;; automatically show the resulting image
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
  (add-hook 'org-clock-in-hook (lambda() (org-todo "DOING")) 'append)


  :bind (("C-c o e" . org-export-dispatch)
         ("C-c o c" . +capture-inbox)
         :map org-mode-map
         ("C-s-q" . org-fill-paragraph)))

(use-package org-agenda
  :after org
  :ensure nil
  :bind (("C-c o A" . org-agenda)
         ("C-c o a" . +switch-to-agenda)
         ("<f1>" . +switch-to-agenda)
         :map org-agenda-mode-map
              ("i" . org-agenda-clock-in)
              ("c" . +capture-inbox)
              ("r" . +org-agenda-process-inbox-item)
              ("R" . org-agenda-refile))
  :config
  ;; Courtesy Jethro Kuan.
  ;; https://blog.jethro.dev/posts/org_mode_workflow_preview/
  (defun +switch-to-agenda()
    (interactive)
    (org-agenda nil " "))

  (defvar +org-agenda-bulk-process-key ?f
    "Default key for bulk processing inbox items.")

  (defun +org-process-inbox ()
    "Called in org-agenda-mode, processes all inbox items."
    (interactive)
    (org-agenda-bulk-mark-regexp "inbox:")
    (+bulk-process-entries))


  (defun +bulk-process-entries ()
    (if (not (null org-agenda-bulk-marked-entries))
        (let ((entries (reverse org-agenda-bulk-marked-entries))
              (processed 0)
              (skipped 0))
          (dolist (e entries)
            (let ((pos (text-property-any (point-min) (point-max) 'org-hd-marker e)))
              (if (not pos)
                  (progn (message "Skipping removed entry at %s" e)
                         (cl-incf skipped))
                (goto-char pos)
                (let (org-loop-over-headlines-in-active-region) (funcall '+org-agenda-process-inbox-item))
                ;; `post-command-hook' is not run yet.  We make sure any
                ;; pending log note is processed.
                (when (or (memq 'org-add-log-note (default-value 'post-command-hook))
                          (memq 'org-add-log-note post-command-hook))
                  (org-add-log-note))
                (cl-incf processed))))
          (org-agenda-redo)
          (unless org-agenda-persistent-marks (org-agenda-bulk-unmark-all))
          (message "Acted on %d entries%s%s"
                   processed
                   (if (= skipped 0)
                       ""
                     (format ", skipped %d (disappeared before their turn)"
                             skipped))
                   (if (not org-agenda-persistent-marks) "" " (kept marked)")))))


  (defvar +org-current-effort "1:00"
    "Current effort for agenda items.")
  (defun +org-agenda-set-effort (effort)
    "Set the effort property for the current headline."
    (interactive
     (list (read-string (format "Effort [%s]: " +org-current-effort) nil nil +org-current-effort)))
    (setq +org-current-effort effort)
    (org-agenda-check-no-diary)
    (let* ((hdmarker (or (org-get-at-bol 'org-hd-marker)
                         (org-agenda-error)))
           (buffer (marker-buffer hdmarker))
           (pos (marker-position hdmarker))
           (inhibit-read-only t)
           newhead)
      (org-with-remote-undo buffer
        (with-current-buffer buffer
          (widen)
          (goto-char pos)
          (org-show-context 'agenda)
          (funcall-interactively 'org-set-effort nil +org-current-effort)
          (end-of-line 1)
          (setq newhead (org-get-heading)))
        (org-agenda-change-all-lines newhead hdmarker))))

  (defun +org-agenda-process-inbox-item ()
    "Process a single item in the org-agenda."
    (interactive)
    (org-with-wide-buffer
     (org-agenda-set-tags)
     (org-agenda-priority)
     (call-interactively '+org-agenda-set-effort)
     (org-agenda-refile nil nil t)))


  (setq org-agenda-custom-commands
        `((" " "Agenda"
           ((agenda ""
                    ((org-agenda-span 'day)
                     (org-deadline-warning-days 365)))
            (todo "TODO"
                  ((org-agenda-overriding-header "To Refile")
                   (org-agenda-files '(,(concat +org-directory "inbox.org")))))
            (todo "DOING"
                  ((org-agenda-overriding-header "In Progress")
                   (org-agenda-files '(,(concat +org-directory "someday.org")
                                       ,(concat +org-directory "projects.org")
                                       ,(concat +org-directory "next.org")))
                   ))
            (todo "TODO"
                  ((org-agenda-overriding-header "Projects")
                   (org-agenda-files '(,(concat +org-directory "projects.org")))
                   ))
            (todo "TODO"
                  ((org-agenda-overriding-header "One-off Tasks")
                   (org-agenda-files '(,(concat +org-directory "next.org")))
                   (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))))
            (todo "BLOCKED"
                  ((org-agenda-overriding-header "Blocked Tasks")
                   (org-agenda-files '(,(concat +org-directory "someday.org")
                                       ,(concat +org-directory "projects.org")
                                       ,(concat +org-directory "next.org")))))
            nil))))

  (setq org-agenda-files `(,+org-directory)
        org-agenda-window-setup 'current-window
        org-agenda-skip-unavailable-files t
        org-agenda-span 10
        org-agenda-block-separator (aref "━" 0)
        org-agenda-start-on-weekday nil
        org-agenda-start-day nil
        org-agenda-inhibit-startup t))



(use-package org-alert
  :disabled
  :init
  (setq alert-default-style 'osx-notifier)
  (setq org-alert-notification-title "Agenda")
  :config (org-alert-enable))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode))
(use-package org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚑" "⇧" "⇩" "☕")))

(use-package org-download
  :bind (("C-c o d c" . org-download-clipboard)
         ("C-c o d d" . org-download-image)
         ("C-c o d x" . org-download-delete))
  :init
  (setq-default org-download-image-dir (concat +org-directory "resource/downloads")))

(use-package org-roam
  :defer 1
  :ensure org-roam
  :ensure org-roam-server
  :ensure company-org-roam
  :bind (:map org-roam-mode-map
              ("C-c o n n" . org-roam-find-file)
              ("C-c o n b" . org-roam-switch-to-buffer)
              ("C-c o n g" . org-roam-graph)
              ("C-c o n u" . org-roam-unlinked-references)
              ("C-c o m"   . org-roam)
              ("C-c o r d" . org-roam-dailies-date)
              ("C-c o r r" . org-roam-dailies-today)
              ("C-c o r m" . org-roam-dailies-tomorrow)
              ("C-c o r y" . org-roam-dailies-yesterday))
  :config
  (org-roam-mode t)
  (add-hook 'org-roam-backlinks-mode-hook 'turn-on-visual-line-mode)
  (defun +do-org-roam-bindings()
    (when (and
           (bound-and-true-p org-roam-mode)
           (org-roam--org-roam-file-p (buffer-file-name (buffer-base-buffer))))
      (local-set-key (kbd "C-i") 'org-roam-insert)))
  (defun open-org-roam ()
    (interactive)
    (and (memq 'org-roam-buffer--update-maybe post-command-hook)
         (not (window-parameter nil 'window-side)) ; don't proc for popups
         (not (eq 'visible (org-roam-buffer--visibility)))
         (with-current-buffer (window-buffer)
           (org-roam-buffer--get-create))))
  (require 'org-roam-protocol)
  ;; (add-hook 'find-file-hook 'open-org-roam)
  (add-hook 'org-roam-buffer-prepare-hook #'hide-mode-line-mode)
  (add-hook 'org-mode-hook '+do-org-roam-bindings)
  (set-popup-rule! "^\\*org-roam unlinked references" :side 'right :size 0.3 :select nil :quit t)
  (setq org-roam-buffer-width 0.22)
  (setq org-roam-verbose nil
        org-roam-buffer-window-parameters '((no-delete-other-windows . t)))
  ;; (push 'company-org-roam company-backends)
  (setq org-roam-directory (concat +org-directory "org-roam/"))
  (setq org-roam-graph-viewer (lambda(url) (+browse-url url))))

(use-package org-noter)
(use-package ox-clip
  :bind ("s-w". ox-clip-formatted-copy))
(use-package org-cliplink
  :bind ("C-c o y" . org-cliplink))

(provide 'core-org)
