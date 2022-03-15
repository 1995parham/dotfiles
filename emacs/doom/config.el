;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq-default
 tab-width 4
 )

(map! :map evil-window-map
      "SPC"        #'rotate-layout
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      )

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Pahram Alvani"
      user-mail-address "parham.alvani@gmail.com")

;; Only parse LaTeX class and package information. [auctex]
;; (setq-default TeX-auto-regexp-list 'LaTeX-auto-minimal-regexp-list)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "JetBrains Mono" :height 1.0)
;;      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :height 1.3))
(setq doom-font (font-spec :family "JetBrains Mono" :size 12))
;;
;; (set-face-attribute 'default nil :font "JetBrains Mono" :height 90)


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-molokai)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Using delete-trailing-whitespaces or whitespace-cleanup to manage leftover whitespace
(add-hook 'after-save-hook #'whitespace-cleanup)

;; change the direction of the content. keybinding is useful in bi-directional document.
(map! :n "M-d" (cmd! (if (eq bidi-paragraph-direction 'left-to-right) (setq bidi-paragraph-direction 'right-to-left) (setq bidi-paragraph-direction 'left-to-right))))
(map! :n "M-a" (cmd! (setq bidi-paragraph-direction nil)))

;; do dont handle M-SPC for osx
(if IS-MAC (global-set-key "\M-SPC" nil))

;; if non-nil, fontify subscript and superscript strings. concretely, this means that thescripts are raised or lowered.
(setq font-latex-fontify-script nil)
(setq tex-fontify-script nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;

;; Setup go development environment
(setenv "GOPATH" (expand-file-name "~/Documents/Go"))
(add-to-list 'exec-path (concat (file-name-as-directory (getenv "GOPATH")) "bin") t)

;; Use pdf-tools to open PDF files
;;(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
;;      TeX-source-correlate-start-server t)

;; Update PDF buffers after successful LaTeX runs
;;(add-hook 'TeX-after-compilation-finished-functions
;;          #'TeX-revert-document-buffer)

;; The information to be shown is normally collected from all agenda files,
;; the files listed in the variable org-agenda-files.
;; If a directory is part of this list, all files with the extension ‘.org’ in this directory are part of the list.
(setq org-agenda-files (quote ("~/tasks")))

;; Better planing for future with org-mode
(after! org
  (setq org-agenda-format-date 'org-agenda-format-date-persian)
  (setq org-cycle-emulate-tab 'never)

  (pushnew! org-link-abbrev-alist
            '("archwiki"      . "https://wiki.archlinux.org/title/%s"))

  (defun org-agenda-format-date-persian (date)
    "format a date string for display in the daily/weekly agenda, or timeline.
        this function makes sure that dates are aligned for easy reading."
    (require 'cal-iso)
    (let* ((dayname (calendar-day-name date 1 nil))
           (day (cadr date))
           (persian-date (substring (calendar-persian-date-string date) 0 -6))
           (month (car date))
           (monthname (calendar-month-name month 1))
           (year (nth 2 date)))
      (format " %-2s. %s %2d %2d, %s"
              dayname monthname day year persian-date)
      )
    )
  (setq org-todo-keywords
        '(
          ;; Tasks
          (sequence "TODO(t)" "PROG(p)" "DONE(d)")
          ;; Books
          (sequence "TOREAD(t)" "READ(d)")
          ;; Goals
          (sequence "GOAL(t)" "ACCOMPL(d)")
          (type "BOOK" "PROJ")
          ))
  (setq org-agenda-start-day ".")
  (setq org-agenda-span 'week)
  (setq org-agenda-todo-ignore-scheduled 'future)
  (setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)
  (setq org-agenda-block-separator nil)
  ;; Personal agenda views
  (setq org-agenda-custom-commands
        '(
          ("n" "Life of Pi"
           ((agenda "" (
                        (org-agenda-span 'day)
                        (org-agenda-overriding-header "Calendar")
                        (org-agenda-prefix-format "   %i %?-2 t%s %b")
                        (org-agenda-skip-scheduled-if-done nil)
                        (org-agenda-time-leading-zero nil)
                        (org-agenda-timegrid-use-ampm nil)
                        (org-agenda-skip-timestamp-if-done t)
                        (org-agenda-skip-deadline-if-done t)
                        (org-agenda-start-day "+0d")
                        (org-agenda-span 2)
                        (org-agenda-repeating-timestamp-show-all nil)
                        (org-agenda-remove-tags t)
                        (org-agenda-todo-keyword-format "")
                        (org-agenda-time)
                        (org-agenda-current-time-string "ᐊ┈┈┈┈┈┈┈ Now")
                        )
                    )
            (todo "TODO" (
                          (org-agenda-overriding-header "\nTo Do")
                          (org-agenda-todo-keyword-format "")
                          (org-agenda-prefix-format " %i %-12:c %b ")
                          )
                  )
            (todo "GOAL" (
                          (org-agenda-overriding-header "\nGoals")
                          (org-agenda-todo-keyword-format "")
                          (org-agenda-prefix-format " %i %-12:c %b ")
                          )
                  )
            (todo "BOOK" (
                          (org-agenda-overriding-header "\nBooks")
                          (org-agenda-todo-keyword-format "")
                          (org-agenda-entry-types '(:scheduled))
                          )
                  )
            )
           () )
          ("b" "Books" ((todo "BOOK")) nil)
          )
        )
  )

;; Use font Vazir for Arabic (Farsi)
(after! unicode-fonts
  (push "Vazirmatn" (cadr (assoc "Arabic" unicode-fonts-block-font-mapping))))

;; Telling bibtex-completion where your bibliographies can be found:
;;(setq bibtex-completion-bibliography
;;      '("~/org/research/main.bib"))

;; Specify where PDFs can be found
;;(setq bibtex-completion-library-path '("~/Documents/Git/parham/citado/papers"))

;; Bibtex-completion supports two methods for storing notes.
;; It can either store all notes in one file or store notes in multiple files, one file per publication.
;; one file per publication is preferred
;;(setq bibtex-completion-notes-path "~/org/research/")

;; switch default action to edit the pdf notes
;;(setq ivy-bibtex-default-action 'ivy-bibtex-edit-notes)

;; use xdg-open to open research papers
;;(setq bibtex-completion-pdf-open-function
;;      (lambda (fpath)
;;        (call-process "xdg-open" nil 0 nil fpath)))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(after! gcmh
        (setq gcmh-high-cons-threshold 100000000))
(setq redisplay-dont-pause t)
