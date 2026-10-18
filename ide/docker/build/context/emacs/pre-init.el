;;; pre-init.el --- pre init customizations  -*- no-byte-compile: t; lexical-binding: t; -*-

;; Editing defaults
(setq-default tab-width 2)
(setq-default make-backup-files nil)
(setq-default display-line-numbers-type 'relative)
(setq-default fill-column 80)
(setq-default sh-basic-offset 2)

;; UI minor modes that need no packages
(column-number-mode 1)
(global-display-line-numbers-mode t)

;; Core keybindings
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "M-Z") 'zap-to-char)

;; Eglot variables (before the package loads)
(setq eglot-autoshutdown t)
(setq eglot-send-changes-idle-time 0.5)

(provide 'pre-init)
;;; pre-init.el ends here
