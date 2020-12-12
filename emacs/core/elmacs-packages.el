
;; Next-generation, purely functional package manager for the Emacs hacker.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "repos/straight.el/bootstrap.el" vendor-dir))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(provide 'elmacs-packages)
