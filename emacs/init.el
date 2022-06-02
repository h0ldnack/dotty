(defvar bootstrap-version)

(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


(straight-use-package 'use-package)
(org-babel-load-file "~/.config/emacs/config.org")



(use-package dracula-theme
  :config (load-theme 'dracula t))

(use-package autorevert
  :delight)

(use-package delight)

(use-package sly
  :config (setq inferior-lisp-program "/run/current-system/sw/bin/sbcl"))

(use-package helm-sly
  :init (global-helm-sly-mode 1)
  :hook (sly-mrepl-hook . helm-sly-disable-internal-completion)
  :config (setq helm-completion-in-region-fuzzy-match t))





(use-package no-littering
  :config (setq no-littering-etc-directory
		(expand-file-name "config/" user-emacs-directory)
		no-littering-var-directory
		(expand-file-name "data/" user-emacs-directory)))

(add-to-list 'recentf-exclude no-littering-var-directory)
(add-to-list 'recentf-exclude no-littering-etc-directory)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))



(use-package company
  :delight
  :hook (prog-mode . company-mode)
  :config (setq company-idle-delay 0.7
		company-minimum-prefix-length 2
		company-selection-wrap-around t))
(company-tng-configure-default)

(use-package company-box
  :delight
  :after company
  :hook (company-mode . company-box-mode)
  :config
  (set-face-background 'company-tooltip "#555555")
  (set-face-background 'company-tooltip-selection "#999999"))




(use-package ace-window
  :bind ("M-t" . ace-window))

(use-package direnv
  :init
  (add-hook 'prog-mode-hook #'direnv-update-environment)
  :config
  (add-to-list 'warning-suppress-types '(direnv))
  (direnv-mode)
  :hook (progn-mode-hook . direnv-allow))

(use-package flycheck
  :delight
  :init (global-flycheck-mode))


; https://github.com/travisbhartwell/nix-emacs/tree/977b9a505ffc8b33b70ec7742f90e469b3168297
(use-package nixos-options)
(use-package company-nixos-options)
(use-package nix-sandbox)

(add-to-list 'company-backends 'company-nixos-options)
(setq flycheck-command-wrapper-function
        (lambda (command) (apply 'nix-shell-command (nix-current-sandbox) command))
      flycheck-executable-find
        (lambda (cmd) (nix-executable-find (nix-current-sandbox) cmd)))

(use-package undo-fu
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z")   'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

(use-package undo-fu-session
  :config (setq undo-fu-session-directory "~/.config/emacs/undo-fu"))
(global-undo-fu-session-mode)


(use-package yasnippet
  :custom (yas-global-mode 1)
  :config (setq yas-snippet-dirs
				'("/datum/yasnippets")))

(use-package nim-mode)
(use-package ebnf-mode
  :mode "\\.ebnf\\'")

(use-package elvish-mode
   :mode "\\.elv'")
