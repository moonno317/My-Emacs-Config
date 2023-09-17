(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
;;Add by myself
(require 'dashboard)
(dashboard-setup-startup-hook)
(use-package emojify
  :hook (after-init . global-emojify-mode))

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'ivy-mode)
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

(setq gc-cons-threshold most-positive-fixnum)

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))


;; Set up keybindings
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Set up additional packages and configurations
;; Add your own packages and configurations here

(defun linux-c-mode ()
 "C mode with adjusted defaults for use with the Linux
kernel."
 (interactive)
 (c-mode)
 (setq c-indent-level 8)
 (setq c-brace-imaginary-offset 0)
 (setq c-brace-offset -8)
 (setq c-argdecl-indent 8)
 (setq c-label-offset -8)
 (setq c-continued-statement-offset 8)
 (setq indent-tabs-mode nil)
 (setq tab-width 8))
(setq auto-mode-alist (cons '("/usr/src/linux.*/.*\\.[ch]
$" . linux-c-mode)
 auto-mode-alist))

(setq dashboard-banner-logo-title "Welcome to Emacs Dashboard")
(setq dashboard-center-content t)
(setq dashboard-show-shortcuts nil)
(defun dashboard-insert-custom (list-size)
  (insert "Good Morning"))
(add-to-list 'dashboard-item-generators  '(custom . dashboard-insert-custom))
(add-to-list 'dashboard-items '(custom) t)
(use-package smart-mode-line :ensure t)
(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                mode-line-frame-identification
                mode-line-buffer-identification
                " "
                mode-line-position
                evil-mode-line-tag
                (vc-mode vc-mode)
                " "
                mode-line-modes
                mode-line-misc-info
                mode-line-end-spaces))
(load-theme 'doom-nord t)
(use-package dashboard
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-banner-logo-title
        (concat " "
                (with-temp-buffer
                  (insert-file-contents "~/.emacs.d/ascii.txt")
                  (buffer-string)))))
(setq dashboard-startup-banner nil)
(use-package elcord
  :ensure t)

(setq which-key-show-early-on-C-h t)
(which-key-mode)
(use-package magit
  :ensure t)
(require 'minimap)
(minimap-mode)
(setq
 minimap-window-location 'right
 minimap-width-fraction 0.0
 minimap-minimum-width 20

 minimap-dedicated-window t
 minimap-enlarge-certain-faces nil)

(use-package lsp-mode
  :hook
  (c-mode . lsp-deferred)
  (c++-mode . lsp-deferred)
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-prefer-flymake nil) ; Use lsp-ui and flycheck instead of flymake
  (setq lsp-clients-clangd-executable "clangd") ; Set the path to clangd executable
  )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'top
        lsp-ui-doc-header t
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable nil
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-diagnostics nil
        lsp-ui-sideline-ignore-duplicate t))

(use-package lsp-treemacs
  :after lsp)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  :config
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-root)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-indent-info t)
  (setq doom-modeline-minor-modes t)
  (setq doom-modeline-mu4e t)
  (setq doom-modeline-irc t)
  ;; Add or remove segments based on your preference
  (doom-modeline-def-segment my-segment
    "Custom segment"
    (concat "My Segment: " (format-time-string "%H:%M")))
  (doom-modeline-def-modeline 'my-custom-modeline
    '(bar workspace-name window-number modals matches buffer-info my-segment))
  (defun setup-custom-modeline ()
    (doom-modeline-set-modeline 'my-custom-modeline))
  (add-hook 'emacs-startup-hook #'setup-custom-modeline))
