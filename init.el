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
  (setq dashboard-banner-logo-title "Tomorrow Will Be A Better Day")
  (setq dashboard-startup-banner "~/Downloads/359895.png")
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-items '((recents   . 5)
                        (bookmarks . 5)
                        (projects  . 5)
                        (agenda    . 5)
                        (registers . 5)))
  (setq dashboard-navigation-cycle t))


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

(use-package spaceline
  :after (ewal-evil-cursors winum)
  :init (setq powerline-default-separator nil)
  :config (spaceline-spacemacs-theme))



(setq doom-modeline-support-imenu t)
(setq doom-modeline-height 25)
(setq doom-modeline-bar-width 4)
(setq doom-modeline-hud nil)
(setq doom-modeline-window-width-limit 85)
(setq doom-modeline-project-detection 'auto)
(setq doom-modeline-buffer-file-name-style 'auto)
(setq doom-modeline-icon t)
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-buffer-modification-icon t)
(setq doom-modeline-lsp-icon t)
(setq doom-modeline-time-icon t)
(setq doom-modeline-time-live-icon t)
(setq doom-modeline-time-analogue-clock t)
(setq doom-modeline-time-clock-size 0.7)
(setq doom-modeline-unicode-fallback nil)
(setq doom-modeline-buffer-name t)
(setq doom-modeline-highlight-modified-buffer-name t)
(setq doom-modeline-column-zero-based t)
(setq doom-modeline-percent-position '(-3 "%p"))
(setq doom-modeline-position-line-format '("L%l"))
(setq doom-modeline-position-column-format '("C%c"))
(setq doom-modeline-position-column-line-format '("%l:%c"))
(setq doom-modeline-minor-modes nil)
(setq doom-modeline-enable-word-count nil)
(setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))
(setq doom-modeline-buffer-encoding t)
(setq doom-modeline-indent-info nil)
(setq doom-modeline-total-line-number nil)
(setq doom-modeline-vcs-icon t)

;; Whether display the icon of check segment. It respects option `doom-modeline-icon'.
(setq doom-modeline-check-icon t)

;; If non-nil, only display one number for check information if applicable.
(setq doom-modeline-check-simple-format nil)

;; The maximum number displayed for notifications.
(setq doom-modeline-number-limit 99)

;; The maximum displayed length of the branch name of version control.
(setq doom-modeline-vcs-max-length 12)

;; Whether display the workspace name. Non-nil to display in the mode-line.
(setq doom-modeline-workspace-name t)

;; Whether display the perspective name. Non-nil to display in the mode-line.
(setq doom-modeline-persp-name t)

;; If non nil the default perspective name is displayed in the mode-line.
(setq doom-modeline-display-default-persp-name nil)

;; If non nil the perspective name is displayed alongside a folder icon.
(setq doom-modeline-persp-icon t)

;; Whether display the `lsp' state. Non-nil to display in the mode-line.
(setq doom-modeline-lsp t)

;; Whether display the GitHub notifications. It requires `ghub' package.
(setq doom-modeline-github nil)

;; The interval of checking GitHub.
(setq doom-modeline-github-interval (* 30 60))

;; Whether display the modal state.
;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
(setq doom-modeline-modal t)

;; Whether display the modal state icon.
;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
(setq doom-modeline-modal-icon t)

;; Whether display the modern icons for modals.
(setq doom-modeline-modal-modern-icon t)

;; When non-nil, always show the register name when recording an evil macro.
(setq doom-modeline-always-show-macro-register nil)

;; Whether display the mu4e notifications. It requires `mu4e-alert' package.
(setq doom-modeline-mu4e nil)
;; also enable the start of mu4e-alert
(mu4e-alert-enable-mode-line-display)

;; Whether display the gnus notifications.
(setq doom-modeline-gnus t)

;; Whether gnus should automatically be updated and how often (set to 0 or smaller than 0 to disable)
(setq doom-modeline-gnus-timer 2)

;; Wheter groups should be excludede when gnus automatically being updated.
(setq doom-modeline-gnus-excluded-groups '("dummy.group"))

;; Whether display the IRC notifications. It requires `circe' or `erc' package.
(setq doom-modeline-irc t)

;; Function to stylize the irc buffer names.
(setq doom-modeline-irc-stylize 'identity)

;; Whether display the battery status. It respects `display-battery-mode'.
(setq doom-modeline-battery t)

;; Whether display the time. It respects `display-time-mode'.
(setq doom-modeline-time t)

;; Whether display the misc segment on all mode lines.
;; If nil, display only if the mode line is active.
(setq doom-modeline-display-misc-in-all-mode-lines t)

;; The function to handle `buffer-file-name'.
(setq doom-modeline-buffer-file-name-function #'identity)

;; The function to handle `buffer-file-truename'.
(setq doom-modeline-buffer-file-truename-function #'identity)

;; Whether display the environment version.
(setq doom-modeline-env-version t)
;; Or for individual languages
(setq doom-modeline-env-enable-python t)
(setq doom-modeline-env-enable-ruby t)
(setq doom-modeline-env-enable-perl t)
(setq doom-modeline-env-enable-go t)
(setq doom-modeline-env-enable-elixir t)
(setq doom-modeline-env-enable-rust t)

;; Change the executables to use for the language version string
(setq doom-modeline-env-python-executable "python") ; or `python-shell-interpreter'
(setq doom-modeline-env-ruby-executable "ruby")
(setq doom-modeline-env-perl-executable "perl")
(setq doom-modeline-env-go-executable "go")
(setq doom-modeline-env-elixir-executable "iex")
(setq doom-modeline-env-rust-executable "rustc")

;; What to display as the version while a new one is being loaded
(setq doom-modeline-env-load-string "...")

;; By default, almost all segments are displayed only in the active window. To
;; display such segments in all windows, specify e.g.
(setq doom-modeline-always-visible-segments '(mu4e irc))

;; Hooks that run before/after the modeline version string is updated
(setq doom-modeline-before-update-env-hook nil)
(setq doom-modeline-after-update-env-hook nil)



(add-to-list 'default-frame-alist '(fullscreen . maximized))
