;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;(setq doom-font (font-spec :family "Inconsolata Nerd Font Mono" :size 12 :weight 'semi-light)
;      doom-variable-pitch-font (font-spec :family "Inconsolata Nerd Font Mono" :size 13))
(setq doom-font (font-spec :family "Inconsolata Nerd Font Mono" :weight 'semi-light))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/")
(setq org-roam-directory org-directory)


(after! org
  (map! :map org-mode-map
        :nv "t" #'org-todo
        )


  (setq org-startup-with-inline-images t) ; show images is on on startup press 'zi' to toggle it
  (setq org-startup-folded 'show2levels) ; expand up to 2 levels of heading on opening org files
  (setq org-log-done 'time)

  (setq org-todo-keywords
        (append org-todo-keywords
                '((sequence "|" "MEETING")))
        )

  (setq +org-capture-todo-file "Inbox.org")
  (setq +org-capture-notes-file "Inbox.org")
  (setq +org-capture-project-todo-file "Inbox.org")
  (setq +org-capture-project-notes-file "Inbox.org")

  (setq org-capture-templates
  '(("t" "New todo" entry
    (file+headline +org-capture-todo-file "Tasks")
    "* TODO %?\n%i\n%a")
   ("n" "Personal notes" entry
    (file+headline +org-capture-notes-file "Notes")
    "* %u %?\n%i\n%a")
   ("j" "Journal" entry
    (file+olp+datetree +org-capture-journal-file)
    "* %U %?\n%i\n%a" :prepend t)

   ("p" "Templates for projects")
   ("pt" "Project-local todo" entry
    (file+headline +org-capture-project-todo-file "Inbox")
    "* TODO %?\n%i\n%a" :prepend t)
   ("pn" "Project-local notes" entry
    (file+headline +org-capture-project-notes-file "Inbox")
    "* %U %?\n%i\n%a" :prepend t)
   ("pc" "Project-local changelog" entry
    (file+headline +org-capture-project-changelog-file "Unreleased")
    "* %U %?\n%i\n%a" :prepend t)

   ("o" "Centralized templates for projects")
   ("ot" "Project todo" entry #'+org-capture-central-project-todo-file "* TODO %?\n %i\n %a" :heading "Tasks" :prepend nil)
   ("on" "Project notes" entry #'+org-capture-central-project-notes-file "* %U %?\n %i\n %a" :heading "Notes" :prepend t)
   ("oc" "Project changelog" entry #'+org-capture-central-project-changelog-file "* %U %?\n %i\n %a" :heading "Changelog" :prepend t))
  )

  (setq org-roam-capture-templates
        '(("d" "default" plain "%?"
           :target (file+head "refs/roam/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("s" "reference software" plain (file "templates/roam-sw.org")
           :target (file+head "refs/roam/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("c" "consumed media" plain (file "templates/roam-consumed-media.org")
           :target (file+head "refs/roam/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)
          ("p" "person default" plain (file "templates/roam-person.org")
           :target (file+head "people/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :unnarrowed t)))

  (setq org-roam-dailies-capture-templates
        (let ((head "#+title: %<%Y-%m-%d (%A)>\n#+startup: showall\n* Journal\n* Content\n* Tasks\n"))
          `(
            ("d" "default" entry "* %?" :target
             (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
            ("j" "journal" entry "** %<%H:%M> %?"
             :target (file+head+olp "%<%Y-%m-%d>.org" ,head ("Journal"))
             :unnarrowed t)
            ("c" "content" entry (file "templates/roam-consumed-media.org")
             :target (file+head+olp "%<%Y-%m-%d>.org" ,head ("Content"))
             :unnarrowed t))
          ))

    (setq org-agenda-custom-commands
          '(("n" "Agenda and all TODOs"
             ((agenda "")
              (alltodo "")))

            ("R" "Refile items"
             ((tags "+refile-hide")))

            ("d" "Review: Daily"
             ((agenda "")
              (tags "+refile-hide")))

            ("." "Review: Daily test"
             ((agenda "")
              (org-ql-block '(or (and (tags "refile")
                                  (not (tags "hide")))
                                 (and ))))
             ((org-agenda-block-separator nil)
              (org-agenda-overriding-header nil)
              (org-ql-block-header "")
              ))
            ))

    (setq org-super-agenda-groups
       '(
         (:name "Refile"
                :tag "refile")
         (:name "Important"
                ;; Single arguments given alone
                :tag "bills"
                :priority "A")
         ;; Set order of multiple groups at once
         (:order-multi (2 (:name "Shopping in town"
                                 ;; Boolean AND group matches items that match all subgroups
                                 :and (:tag "shopping" :tag "@town"))
                          (:name "Food-related"
                                 ;; Multiple args given in list with implicit OR
                                 :tag ("food" "dinner"))
                          (:name "Personal"
                                 :habit t
                                 :tag "personal")
                          (:name "Space-related (non-moon-or-planet-related)"
                                 ;; Regexps match case-insensitively on the entire entry
                                 :and (:regexp ("space" "NASA")
                                               ;; Boolean NOT also has implicit OR between selectors
                                               :not (:regexp "moon" :tag "planet")))))
         ;; Groups supply their own section names when none are given
         (:todo "WAITING" :order 8)  ; Set order of this section
         (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
                ;; Show this group at the end of the agenda (since it has the
                ;; highest number). If you specified this group last, items
                ;; with these todo keywords that e.g. have priority A would be
                ;; displayed in that group instead, because items are grouped
                ;; out in the order the groups are listed.
                :order 9)
         (:priority<= "B"
                      ;; Show this section after "Today" and "Important", because
                      ;; their order is unspecified, defaulting to 0. Sections
                      ;; are displayed lowest-number-first.
                      :order 1)
         ;; After the last group, the agenda will display items that didn't
         ;; match any of these groups, with the default order position of 99
         ))

  )

(use-package! org-super-agenda
  :after (org)
  )

(use-package! org-ql
  :after (org)
  )


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
