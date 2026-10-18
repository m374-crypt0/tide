;;; pre-early-init.el --- pre early init customizations  -*- no-byte-compile: t; lexical-binding: t; -*-

;; prevent a circular dependency: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=803060&pow_referer=
(setq load-prefer-newer nil)

;; Reducing clutter in ~/.emacs.d by redirecting files to ~/.emacs.d/var/
(setq user-emacs-directory
      (expand-file-name "var/" minimal-emacs-user-directory))
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))
