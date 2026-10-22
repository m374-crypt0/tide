;;; post-early-init.el --- post early init customizations  -*- no-byte-compile: t; lexical-binding: t; -*-

;; Theme and frame appearance
(setq frame-background-mode 'dark)

;; Prevent GUI flicker on startup
(menu-bar-mode -1)

;; Terminal mouse support
(when (not (display-graphic-p))
  (xterm-mouse-mode 1))

(provide 'post-early-init)
