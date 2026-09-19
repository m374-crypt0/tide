;; -*- lexical-binding: t; -*-
(menu-bar-mode -1)

(setq make-backup-files nil)
(setq display-line-numbers-type 'relative)
(setq fill-column 80)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(global-display-line-numbers-mode t)

(load custom-file 'noerror)

(global-set-key (kbd "M-Z") 'zap-up-to-char)

(require 'package)
(add-to-list
 'package-archives '("melpa" . "https://melpa.org/packages/")
 t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq frame-background-mode 'dark)
(use-package
 batppuccin
 :ensure t
 :config (load-theme 'batppuccin-mocha :no-confirm))

(use-package
 eglot
 :ensure nil
 :config
 (setq eglot-autoshutdown t)
 (setq eglot-send-changes-idle-time 0.5))

(use-package
 yaml-mode
 :ensure t
 :mode "\\.ya?ml\\'"
 :hook
 ((yaml-mode . eglot-ensure)
  (yaml-mode
   .
   (lambda ()
     (setq-local yaml-indent-offset 2)
     (setq-local tab-width 2)
     (setq-local indent-tabs-mode nil))))
 :config
 (setq yaml-indent-offset 2)) ; fallback default

;; auto-formating
;; yaml
(add-hook
 'yaml-mode-hook
 (lambda ()
   (add-hook 'before-save-hook
             (lambda () (save-excursion (eglot-format-buffer)))
             nil t)))

;; elisp
(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (add-hook 'before-save-hook
             (lambda () (save-excursion (elisp-autofmt-buffer)))
             nil t)))

;; ensure: mpm i -g bash-language-server
;; ensure: shellcheck binary is reachable
(use-package sh-mode :ensure nil :hook (sh-mode . eglot-ensure))

(use-package
 emacs-lisp-mode
 :ensure nil
 :mode ("\\.el\\'" . emacs-lisp-mode)
 :hook
 ((emacs-lisp-mode . eglot-ensure) (emacs-lisp-mode . eldoc-mode)))

(use-package
 company
 :ensure t
 :hook (yaml-mode . company-mode)
 :config
 (setq company-idle-delay 0.2)
 (setq company-minimum-prefix-length 2)
 (setq company-selection-wrap-around t)
 (setq company-backends '((company-capf company-files))))

(global-company-mode 1)

(use-package ghostel :ensure t)

(use-package nerd-icons :ensure t)

(use-package
 nerd-icons-completion
 :ensure t
 :after (nerd-icons)
 :config (nerd-icons-completion-mode 1))

(use-package
 nerd-icons-dired
 :ensure t
 :after (nerd-icons)
 :hook (dired-mode . nerd-icons-dired-mode))

(use-package
 doom-modeline
 :ensure t
 :after (nerd-icons)
 :hook (after-init . doom-modeline-mode)
 :config
 (setq
  doom-modeline-icon t
  doom-modeline-major-mode-icon t
  doom-modeline-buffer-file-name-style 'truncated-with-project))

(use-package
 centaur-tabs
 :ensure t
 :after (nerd-icons)
 :config
 (setq centaur-tabs-set-icons t)
 (centaur-tabs-mode 1))

(use-package nov :ensure t :pin melpa)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(use-package workgroups2 :ensure t)
(setq wg-session-file "~/.emacs.d/.emacs_workgroups")

;; Surrounding with embrace
(use-package embrace :ensure t :bind ("C-," . embrace-commander))

;; Jumping with avy
(use-package
 avy
 :ensure t
 :bind (("M-g c" . avy-goto-char) ("M-g w" . avy-goto-word-1)))

(use-package dotenv-mode :ensure t :mode "\\.env\\(\\..+\\)?\\'")

;; === Eglot + Flymake coexistence ===
;; Tell Eglot globally to stay out of Flymake, so other backends (like Hadolint)
;; survive Eglot's takeover of `flymake-diagnostic-functions'.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-stay-out-of 'flymake))

;; Re-add Eglot's own Flymake backend after Eglot finishes managing the buffer.
;; This runs in every Eglot-managed buffer, so YAML, Bash, Markdown, etc.
;; keep their Eglot diagnostics.
(defun my-eglot-flymake-reactivate ()
  (add-hook 'flymake-diagnostic-functions #'eglot-flymake-backend
            nil
            t)
  (flymake-mode 1))

(add-hook 'eglot-managed-mode-hook #'my-eglot-flymake-reactivate)

(use-package flymake-hadolint :ensure t)

;; ensure: npm i -g dockerfile-language-server-nodejs
(use-package
 dockerfile-mode
 :ensure t
 :mode ("\\(.*\\.\\)?Dockerfile\\'" . dockerfile-mode)
 :hook
 ((dockerfile-mode . eglot-ensure)
  (dockerfile-mode . flymake-hadolint-setup)))

(use-package
 markdown-toc
 :ensure t
 :after markdown-mode
 :config
 (define-key
  markdown-mode-map (kbd "C-c C-t") 'markdown-toc-generate-toc))

;; ensure: npm i -g markdownlint-lsp
;; Markdown editing
(use-package
 markdown-mode
 :ensure t
 :pin melpa
 :mode ("\\.md\\'" "\\.markdown\\'")
 :hook (markdown-mode . eglot-ensure))

;; Register markdownlint-lsp with Eglot
(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   '(markdown-mode . ("markdownlint-lsp-server" "--stdio"))))

(use-package
 devdocs
 :ensure t
 :pin melpa
 :bind ("C-h D" . 'devdocs-lookup))

(use-package uniline :ensure t :defer t :commands uniline-mode)
