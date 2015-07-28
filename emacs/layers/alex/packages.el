;;; packages.el --- alex Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defvar alex-packages
  '(
    org
    )
  "List of all packages to install and/or initialize. Built-in packages
which require an initialization must be listed explicitly in the list.")

(defvar alex-excluded-packages '()
  "List of packages to exclude.")

;; For each package, define a function alex/init-<package-alex>
;;
;; (defun alex/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

(defun alex/init-org ()
  (use-package org
    :defer t
    :config
    (progn
      (setq org-directory (expand-file-name "~/Documents/org"))
      (setq org-default-notes-file (concat org-directory "/notes.org"))

      (setq org-startup-indented nil)

      (define-key global-map "\C-cc" 'org-capture)
      (global-set-key (kbd "\C-ca") 'org-agenda)
    )
  )
)
