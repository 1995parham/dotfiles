(setq-default
  tab-width 4
  )

;; Always load newest byte code
(setq load-prefer-newer t)

;; Define the directory structure
(defvar core-dir (expand-file-name "core" user-emacs-directory)
  "The home of the core functionalities.")
;; please note that vendor directory cannpt change
(defvar vendor-dir (expand-file-name "straight" user-emacs-directory)
  "This directory houses packages.")
(defvar savefile-dir (expand-file-name "savefile" user-emacs-directory)
  "This folder stores all the automatically generated save/history-files.")

(unless (file-exists-p savefile-dir)
  (make-directory savefile-dir))

;; add directories to Emacs's `load-path'
(add-to-list 'load-path core-dir)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(message "Loading core modules...")

;; load the core stuff
(require 'elmacs-packages)
(require 'elmacs-ui)
(require 'elmacs-core)
(require 'elmacs-extension)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Pahram Alvani"
      user-mail-address "parham.alvani@gmail.com")

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Using delete-trailing-whitespaces or whitespace-cleanup to manage leftover whitespace
(add-hook 'after-save-hook #'whitespace-cleanup)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '("" invocation-name " Prelude - " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))
