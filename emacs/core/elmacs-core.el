;; projectile is a project management mode
(straight-use-package 'projectile)
(require 'projectile)
(setq projectile-cache-file (expand-file-name  "projectile.cache" savefile-dir))
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode t)

;; Visualize Emacs undo information as a graphical tree and navigate to previous states
(straight-use-package 'undo-tree)
(global-undo-tree-mode)

;; Language Server Protocol support with multiples languages support for Emacs
(straight-use-package 'lsp-mode)
(straight-use-package 'lsp-ui)
;; Modular in-buffer completion framework for Emacs
(straight-use-package '(company-mode :type git :host github :repo "company-mode/company-mode"))

;; The extensible vi layer for Emacs.
(straight-use-package 'evil)
(require 'evil)
(evil-mode 1)
(setq evil-undo-system 'undo-tree)

;; Theme
(straight-use-package 'doom-themes)
(require 'doom-themes)
(load-theme 'doom-molokai t)

;; show available keybindings after you start typing
;; and with C-h it gives you more hints
(straight-use-package 'which-key)
(require 'which-key)
(which-key-mode t)

(straight-use-package 'nlinum)
(require 'nlinum)
;; show line numbers at the beginning of each line
;; there's a built-in linum-mode, but we're using
;; nlinum-mode, as it's supposedly faster
(global-nlinum-mode t)
(setq nlinum-highlight-current-line t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; It's Magit! A Git porcelain inside Emacs.
(straight-use-package 'magit)
(require 'magit)

;; A emacs tree plugin like NerdTree for Vim.
(straight-use-package 'neotree)

;; Bi-directional support (useful in persian documents)
(defun switch-bidi-direction () "Change writing direction" (interactive)
  (if (eq bidi-paragraph-direction 'left-to-right) (setq bidi-paragraph-direction 'right-to-left) (setq bidi-paragraph-direction 'left-to-right))
  )
(global-set-key (kbd "M-d") 'switch-bidi-direction)


(provide 'elmacs-core)
