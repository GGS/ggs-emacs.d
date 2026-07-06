;;; pre-early-init.el --- Pre-early init file -*- no-byte-compile: t; lexical-binding: t; -*-
;;(setq minimal-emacs-ui-features '(context-menu tool-bar menu-bar dialogs tooltips))
;;; Уменьшение беспорядка в ~/.emacs.d путём перенаправления файлов в ~/.emacs.d/var/
;; ПРИМЕЧАНИЕ: Это должно быть помещено в 'pre-early-init.el'.
(setq user-emacs-directory (expand-file-name "var/" minimal-emacs-user-directory))
(setq package-user-dir (expand-file-name "elpa" user-emacs-directory))

(defun display-startup-time ()
  "Display the startup time and number of garbage collections." ;
  (message "Emacs init loaded in %.2f seconds (Full emacs-startup: %.2fs) with %d garbage collections."
           (float-time (time-subtract after-init-time before-init-time))
           (time-to-seconds (time-since before-init-time))
           gcs-done))

(add-hook 'emacs-startup-hook #'display-startup-time 100)
