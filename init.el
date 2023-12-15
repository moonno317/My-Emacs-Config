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
(setq which-key-show-early-on-C-h t)
(which-key-mode)
(use-package magit
  :ensure t)


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
    (concat "My Segment: " (format-time-string "%H:%M ")))
  (doom-modeline-def-modeline 'my-custom-modeline
    '(bar workspace-name window-number modals matches buffer-info my-segment))
  (defun setup-custom-modeline ()
    (doom-modeline-set-modeline 'my-custom-modeline))
  (add-hook 'emacs-startup-hook #'setup-custom-modeline))

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :custom
  (company-backends '(company-capf)))

(use-package lsp-mode
  :ensure t
  :hook (prog-mode . lsp-deferred)
  :custom
  (lsp-prefer-capf t)
  (lsp-auto-guess-root t)             
  (lsp-keep-workspace-alive nil))
(defun dotfiles--lsp-deferred-if-supported ()
  "Run `lsp-deferred' if it's a supported mode."
  (unless (derived-mode-p 'emacs-lisp-mode)
    (lsp-deferred)))

(add-hook 'prog-mode-hook #'dotfiles--lsp-deferred-if-supported)


(use-package dashboard
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-banner-logo-title
        (concat " "
                (with-temp-buffer
                  (insert-file-contents "~/.emacs.d/ascii.txt")
                  (buffer-string)))))
(setq dashboard-startup-banner nil)


(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/theme 'powerline)
  (setq sml/no-confirm-load-theme t)
  (setq sml/name-width 20) ; Adjust the width of the mode-line segment

  ;; Customize the mode-line separators
  (setq sml/separator-scale 0.8)
  (setq sml/separator-width 1)
  (setq sml/mode-width 'full)

  ;; Set custom faces for the mode-line segments
  (custom-set-faces
   '(mode-line ((t (:background "#F5F5F5" :foreground "#333333" :box nil))))
   '(mode-line-inactive ((t (:background "#EAEAEA" :foreground "#999999" :box nil))))
   '(sml/filename ((t (:foreground "#333333"))))
   '(sml/prefix ((t (:foreground "#E67E80"))))
   '(sml/read-only ((t (:foreground "#C594C5"))))
   '(sml/modes ((t (:foreground "#6C9EF8"))))
   '(sml/position-percentage ((t (:foreground "#99C794"))))
   '(sml/vc ((t (:foreground "#C594C5" :weight bold))))
   '(sml/git ((t (:foreground "#C594C5" :weight bold))))
   '(sml/process ((t (:foreground "#6C9EF8"))))
   '(sml/narrowed ((t (:foreground "#E06C75")))))

  :init
  (add-hook 'after-init-hook 'sml/setup))

(use-package ewal
  :init (setq ewal-use-built-in-always-p nil
              ewal-use-built-in-on-failure-p t
              ewal-built-in-palette "sexy-material"))
(use-package ewal-spacemacs-themes
  :init (progn
          (setq spacemacs-theme-underline-parens t
                my:rice:font (font-spec
                              :family "Source Code Pro"
                              :weight 'semi-bold
                              :size 11.0))
          (show-paren-mode +1)
          (global-hl-line-mode)
          (set-frame-font my:rice:font nil t)
          (add-to-list  'default-frame-alist
                        `(font . ,(font-xlfd-name my:rice:font))))
  :config (progn
            (load-theme 'ewal-spacemacs-modern t)
            (enable-theme 'ewal-spacemacs-modern)))
(use-package spaceline
  :after (ewal-evil-cursors winum)
  :init (setq powerline-default-separator nil)
  :config (spaceline-spacemacs-theme))

(set-frame-parameter nil 'alpha-background 75)
(add-to-list 'default-frame-alist '(alpha-background . 75))
