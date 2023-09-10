;; Set up package management
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)


;;Add by myself
(require 'dashboard)
(dashboard-setup-startup-hook)
(use-package emojify
  :hook (after-init . global-emojify-mode))

(add-hook 'after-init-hook 'global-company-mode)

(package-install 'helm)
(require 'helm)
(defun my-find-file ()
  (interactive)
  (helm-find-files (expand-file-name default-directory)))
(global-set-key (kbd "C-x C-f") 'my-find-file)
(setq default-directory "/home/vers/")


;; Install and configure use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; Set up customizations directory
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; Set up basic UI preferences
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-screen t)
(setq-default cursor-type 'bar)
(setq-default tab-width 4)
(global-display-line-numbers-mode)

(setq-default cursor-type 'box)



;; Set up themes
(use-package solarized-theme
  :ensure t
  :init
  (load-theme 'solarized-light t))

;; Set up keybindings
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Set up additional packages and configurations
;; Add your own packages and configurations here
