(setq straight-use-package-by-default t)
(setq gc-cons-threshold 100000000)
(setq-default tab-width 4)
(setq inhibit-splash-screen t) 
(setq delete-by-moving-to-trash t)
(setq trash-directory "/datum/trash")
(setq backup-directory-alist `(("." . "~/.config/emacs/backups")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 60)
(run-at-time nil (* 5 60) 'recentf-save-list)
(defalias 'yes-or-no-p 'y-or-n-p)

(use-package org-super-agenda
      :config (setq org-super-agenda-mode 1))

(use-package org-bullets
      :hook (org-mode . (lambda () (org-bullets-mode 1))))

(add-to-list 'org-babel-default-header-args
		       '(:results . "silent"))

(setq org-archive-location "/notes/archive.org")
(setq org-directory "/notes/")
(setq org-confirm-babel-evaluate nil)
(setq org-support-shift-select t)
(setq org-src-fontify-natively t)
(setq org-descriptive-links t)
(setq org-ellipsis "…")
(org-clock-persistence-insinuate)
(setq org-clock-out-when-done t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
(setq org-clock-into-drawer t)
(setq org-clock-persist t)
(setq org-clock-in-resume t)
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
(setq org-clock-persist-query-resume nil)
(setq org-todo-keywords
	      (quote ((sequence "TODO(t)" "ACTIVE(a)" "|" "DONE(d)"))))

(setq org-agenda-files (quote ("/notes/projects.org"
							       "/notes/todos.org"
							       )))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
       (js . t)
       (emacs-lisp . t)
       (shell . t)))
(setq calendar-week-start-day 1)

(use-package flyspell
      :hook (text-mode-hook . flyspell-mode))

(use-package flyspell-correct
      :after flyspell
      :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))

(use-package flyspell-correct-helm
      :after flyspell-correct)

(with-eval-after-load "ispell"
      ;; Configure `LANG`, otherwise ispell.el cannot find a 'default
      ;; dictionary' even though multiple dictionaries will be configured
      ;; in next line.
      (setenv "LANG" "en_US.UTF-8")
      (setq ispell-program-name "hunspell")
      ;; Configure German, Swiss German, and two variants of English.
      (setq ispell-dictionary "en_US")
      ;; ispell-set-spellchecker-params has to be called
      ;; before ispell-hunspell-add-multi-dic will work
      (ispell-set-spellchecker-params)
      (ispell-hunspell-add-multi-dic "en_US")
      ;; For saving words to the personal dictionary, don't infer it from
      ;; the locale, otherwise it would save to ~/.hunspell_de_DE.
      (setq ispell-personal-dictionary "~/.dotty/hunspell/personal_dict"))

;; The personal dictionary file has to exist, otherwise hunspell will
;; silently not use it.
;(unless (file-exists-p ispell-personal-dictionary)
      ;(write-region "" nil ispell-personal-dictionary nil 0))

(use-package python
      :custom	(python-shell-interpreter "python"))
(use-package poetry
      :hook (python-mode . poetry-tracking-mode))
(use-package elpy
      :delight
      :init
      (elpy-enable)
      :config  (setq python-shell-interpreter "ipython"
				 python-shell-interpreter-args "-i --simple-prompt"))

(when (load "flycheck" t t)
      (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
      (add-hook 'elpy-mode-hook 'flycheck-mode))
(add-hook 'elpy-mode-hook (lambda ()
							(add-hook 'before-save-hook
									      'elpy-black-fix-code nil t)))

(use-package lsp-mode
      :init
      ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
      (setq lsp-keymap-prefix "C-l")
      :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
		 (css-mode . lsp-deferred)
		 (go-mode . lsp-deferred))
      :config
      (setq lsp-prefer-flymake nil)
      (setq lsp-headerline-breadcrumb-enable t)
      :custom
      (lsp-idle-delay 0.6)
      :commands (lsp lsp-deferred))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package helm-lsp :commands helm-lsp-workspace-symbol)

(use-package ws-butler
      :config (add-hook 'prog-mode-hook #'ws-butler-mode))

(use-package web-mode
      :mode ("\\.html\\'")
      :config
      (setq web-mode-markup-indent-offset 2)
      (setq web-mode-engines-alist
		'(("django" . "focus/.*\\.html\\'")
		      ("ctemplate" . "realtimecrm/.*\\.html\\'"))))

(use-package go-mode
      :config
      (add-hook 'before-save-hook 'gofmt-before-save))

(use-package fish-mode)
(use-package rainbow-delimiters
      :init (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))
(use-package tree-sitter
      :config (global-tree-sitter-mode)
      :delight
      :hook (tree-sitter-after-on . tree-sitter-hl-mode))
(use-package tree-sitter-langs)
(use-package tree-sitter-indent)
(use-package nix-mode)
(use-package poly-markdown)
(use-package rainbow-mode)
(use-package csharp-mode
      :config
      (add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-tree-sitter-mode)))

(use-package helm
      :bind (("M-x" . helm-M-x)
		 ("M-y" . helm-show-kill-ring)
		 ("C-x C-f" . helm-find-files))
      :config (setq helm-mode-fuzzy-match t
				helm-completion-in-region-fuzzy-match t
				helm-candidate-number-limit 120
				helm-autoresize-mode 1
				helm-autoresize-max-height 24
				helm-autoresize-min-height 8))

(use-package ace-window
      :setq (config aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))
(global-set-key (kbd "M-t") 'ace-window)

(use-package ujelly-theme
      :config
      (load-theme 'ujelly t))
;(set-face-attribute 'default t :font Hack )
;(set-default-font "hack")
(set-face-attribute 'default nil
                  :family "Fira Code"
                  :height 100
                  :weight 'normal
                  :width 'normal)

(use-package undo-fu
      :config
      (global-unset-key (kbd "C-z"))
      (global-set-key (kbd "C-z")   'undo-fu-only-undo)
      (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))
(use-package undo-fu-session
      :config
      (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")
		undo-fu-session-compression 'zst
		undo-fu-session-file-limit 2000))

(global-undo-fu-session-mode)
