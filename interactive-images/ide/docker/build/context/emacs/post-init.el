;;; post-init.el --- post init customizations  -*- no-byte-compile: t; lexical-binding: t; -*-

;; Custom file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; Theme
(use-package batppuccin :ensure t)

;; --- All your use-package blocks ---
(use-package eglot :ensure nil)

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

;; ensure: npm i -g bash-language-server
;; ensure: shellcheck binary is reachable
(use-package
 sh-mode
 :ensure nil
 :hook
 ((sh-mode . eglot-ensure) (sh-mode . (lambda () (auto-fill-mode 1)))))

(use-package
 emacs-lisp-mode
 :ensure nil
 :mode ("\\.el\\'" . emacs-lisp-mode)
 :hook ((emacs-lisp-mode . eglot-ensure) (emacs-lisp-mode . eldoc-mode)))

(use-package elisp-autofmt :ensure t)

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

;; ensure: npm i -g dockerfile-language-server-nodejs
(use-package
 dockerfile-mode
 :ensure t
 :mode ("\\(.*\\.\\)?Dockerfile\\'" . dockerfile-mode)
 :hook
 ((dockerfile-mode . eglot-ensure) (dockerfile-mode . flymake-hadolint-setup)))

(use-package
 markdown-toc
 :ensure t
 :after markdown-mode
 :config
 (define-key markdown-mode-map (kbd "C-c C-t") #'markdown-toc-generate-toc))

;; ensure: npm i -g markdownlint-lsp
;; Markdown editing
(use-package
 markdown-mode
 :ensure t
 :pin melpa
 :mode ("\\.md\\'" "\\.markdown\\'")
 :hook
 ((markdown-mode . eglot-ensure)
  (markdown-mode
   .
   (lambda ()
     (setq-local fill-column 80)
     (auto-fill-mode 1)))))

(use-package devdocs :ensure t :pin melpa :bind ("C-h D" . devdocs-lookup))

(use-package uniline :ensure t :defer t :commands uniline-mode)

(use-package magit :ensure t :pin melpa)

(use-package git-gutter :ensure t :config (global-git-gutter-mode +1))

(use-package magit-todos :ensure t :after magit :config (magit-todos-mode 1))

(use-package docker :ensure t :bind ("C-c d" . docker))

(use-package flymake-hadolint :ensure t)

(use-package
 cc-mode
 :ensure nil
 :hook
 ((c-mode . eglot-ensure)
  (c++-mode . eglot-ensure)
  (c-or-c++-mode . eglot-ensure))
 :config
 ;; .h files as C++
 (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)))

(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   '((c-mode de c-or-c++-mode)
     .
     ("clangd"
      "-j=4"
      "--background-index"
      "--clang-tidy"
      "--header-insertion=never"))))

(use-package
 cmake-mode
 :ensure t
 :mode (("CMakeLists\\.txt\\'" . cmake-mode) ("\\.cmake\\'" . cmake-mode))
 :hook (cmake-mode . eglot-ensure))

(use-package auto-highlight-symbol :ensure t)

(use-package gptel :ensure t :pin melpa :defer t)

(use-package
 gptel-agent
 :vc (:url "https://github.com/karthink/gptel-agent" :rev :newest)
 :config (gptel-agent-update)) ;Read files from agents directories

;; LLM interactions
(setq gptel-backend
      (gptel-make-openai
       "gptel-backend"
       :host
       (format "%s:%s"
               (or (getenv "IDE_INFERENCE_HOST") "localhost")
               (or (getenv "IDE_INFERENCE_PORT") "8000"))
       :protocol "http"
       :stream t
       :models
       (list
        (or (getenv "IDE_INFERENCE_MODEL")
            "Ornith-1.0-35B-ROCmFPX-Speed-StrixHalo.gguf"))))

(setq gptel-model
      (or (getenv "IDE_INFERENCE_MODEL")
          "Ornith-1.0-35B-ROCmFPX-Speed-StrixHalo.gguf"))

;; auto highlighting
(global-auto-highlight-symbol-mode t)
(add-to-list 'ahs-modes 'dockerfile-mode)

;; Register neocmakelsp with Eglot
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs '(cmake-mode . ("neocmakelsp" "stdio"))))

;; Register markdownlint-lsp with Eglot
(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   '(markdown-mode . ("markdownlint-lsp-server" "--stdio"))))

;; --- Auto-format hooks ---
(add-hook
 'yaml-mode-hook
 (lambda ()
   (add-hook
    'before-save-hook (lambda () (save-excursion (eglot-format-buffer)))
    nil t)))

(add-hook
 'dockerfile-mode-hook
 (lambda ()
   (add-hook
    'before-save-hook (lambda () (save-excursion (eglot-format-buffer)))
    nil t)))

(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (add-hook
    'before-save-hook (lambda () (save-excursion (elisp-autofmt-buffer)))
    nil t)))

(add-hook
 'cmake-mode-hook
 (lambda ()
   (add-hook
    'before-save-hook (lambda () (save-excursion (eglot-format-buffer)))
    nil t)))

(add-hook
 'c++-mode-hook
 (lambda ()
   (add-hook
    'before-save-hook (lambda () (save-excursion (eglot-format-buffer)))
    nil t)))

;; --- Theme hook, avoiding race condition with safe theme ---
(add-hook
 'after-init-hook (lambda () (load-theme 'batppuccin-mocha :no-confirm)))

;; --- Eglot + Flymake coexistence ---
(with-eval-after-load 'eglot
  (add-to-list 'eglot-stay-out-of 'flymake))

(defun my-eglot-flymake-reactivate ()
  (add-hook 'flymake-diagnostic-functions #'eglot-flymake-backend nil t)
  (flymake-mode 1))

(add-hook 'eglot-managed-mode-hook #'my-eglot-flymake-reactivate)

;; magit hooks
(add-hook 'magit-post-refresh-hook #'git-gutter:update-all-windows)

;; --- Git prefix keymap ---
(define-prefix-command 'git-tools-prefix)
(global-set-key (kbd "C-x g") 'git-tools-prefix)
(define-key git-tools-prefix (kbd "g") #'magit-status)
(define-key git-tools-prefix (kbd "v") #'git-gutter:popup-hunk)
(define-key git-tools-prefix (kbd "n") #'git-gutter:next-hunk)
(define-key git-tools-prefix (kbd "p") #'git-gutter:previous-hunk)
(define-key git-tools-prefix (kbd "r") #'git-gutter:revert-hunk)
(define-key git-tools-prefix (kbd "s") #'git-gutter:stage-hunk)

;; --- misc ---
(global-hl-todo-mode 1)

(provide 'post-init)
;;; post-init.el ends here
