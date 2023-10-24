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
        "M-n" #'org-roam-dailies-goto-next-note
        "M-p" #'org-roam-dailies-goto-previous-note
        )


  (setq org-startup-with-inline-images t ; show images is on on startup press 'zi' to toggle it
        org-startup-folded 'show2levels ; expand up to 2 levels of heading on opening org files
        org-log-done 'time
        org-fontify-done-headline nil
        org-fontify-whole-heading-line nil)

  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "LOOP(r)"  ; A recurring task
           "NEXT(n)"  ; The planned next task to be done in a group of tasks
           "STRT(s)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "IDEA(i)"  ; An unconfirmed and unapproved task or notion
           "|"
           "DONE(d)"  ; Task successfully completed
           "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "TO-MEET(m)"  ; scheduled meeting
           "|"
           "MEETING(M)") ; concluded meeting
          (sequence
           "PROJECT(p)"   ; A project, which usually contains other tasks
           "PROJ"         ; Like PROJECT
           "PAUSED(P)"    ; A project started but was paused (is on hold) for whatever reason
           "|"
           "COMPLETE(c)")) ; A project that is finished/complete

        org-todo-keyword-faces
        '(("STRT" . +org-todo-active)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("KILL" . +org-todo-cancel)

          ("PROJ" . +org-todo-project)
          ("PROJECT" . +org-todo-project)
          ("PAUSED" . +org-todo-project)
          ;("COMPLETE" . +org-todo-project)
        ))

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
        '(("d" "default" plain (file "templates/roam-default.org")
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
        (let ((head "#+title: %<%Y-%m-%d (%A)>\n#+startup: showall\n* Journal\n* Content\n*Meetings\n* Tasks\n"))
          `(
            ("d" "default" entry "* %?" :target
             (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
            ("j" "journal" entry "** %<%H:%M> %?"
             :target (file+head+olp "%<%Y-%m-%d>.org" ,head ("Journal"))
             :unnarrowed t)
            ("m" "meeting" entry (file "templates/meeting.org")
             :target (file+head+olp "%<%Y-%m-%d>.org" ,head ("Meetings"))
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
           ((agenda ""
                    ((org-agenda-start-day "-1d")
                     (org-agenda-span 4)
                     (org-agenda-include-diary t)))

            (org-ql-block '(or
                            (and (tags "refile")
                                 (not (tags "hide"))
                                 (and (not (heading "Tasks")) (not (heading "Inbox")) (not (heading "Notes")))
                                 )

                            (and (todo "WAIT")
                                 (not (ts-active :to "9999-01-01"))
                                 (not (tags "hide")))

                            (and (not (todo "DONE" "PROJECT" "PROJ" "KILL"))
                                 (not (tags "hide"))
                                 (priority "A" "B" "C")
                                 (not (ts-active :to "9999-01-01")))

                            (and (todo "PROJECT" "PROJ")
                                 (not (tags "hide")))

                            (and (todo "PROJECT" "PROJ")
                                 (not (tags "hide")))

                            (and (not (todo "DONE" "KILL"))
                                 (tags "easy")
                                 (not (tags "hide")))
                            )
                          ((org-agenda-block-separator nil)
                           (org-agenda-overriding-header nil)
                           (org-ql-block-header "")
                           (org-super-agenda-groups '(
                              (:name "Refile" :tag ("refile") :order 1)
                              (:name "Important" :and (:priority>= "B" :not (:todo ("PROJ" "PROJECT"))) :order 2)
                              (:name "Notable" :and (:priority "C" :not (:todo ("PROJ" "PROJECT"))) :order 3)
                              (:name "Active Projects" :and (:todo ("PROJ" "PROJECT")) :order 4)
                              (:name "Waiting" :todo ("WAIT") :order 5)
                              (:name "Some easier todos (max 3)" :take (3 (:tag ("easy"))) :order 6 )))
                           ))
            ))
          ))

(defun my/org-property ()
    "gets the value of property"

    (org-element-map (org-element-at-point) 'keyword
      (lambda (el) (and
                    (string= (org-element-property :key el) "PROPERTY")
                    (let* ((strings (split-string (org-element-property :value el)))
                           (value (string-join (cdr strings) " "))
                           (name (car strings)))
                      (cons name value))))))

  )

(use-package! org-super-agenda
  :after (org-agenda)

  :config
  ; see https://github.com/alphapapa/org-super-agenda/issues/50#issuecomment-817432643
  (setq org-super-agenda-header-map (make-sparse-keymap))
  ;; (setq org-super-agenda-groups
  ;;       '(
  ;;         (:name "Refile"
  ;;          :tag ("refile")
  ;;          :order 1)
  ;;         (:name "Important"
  ;;          :priority>= "B"
  ;;          :order 2
  ;;          :time-grid t)
  ;;         (:name "Notable"
  ;;          :priority "C"
  ;;          :order 3)
  ;;         (:name "Waiting"
  ;;          :todo ("WAIT")
  ;;          :order 4)))
  (org-super-agenda-mode)
)

(use-package! org-ql
  :after (org)
)

(use-package! org-roam-ql
  :after (org-roam)
  :bind ((:map org-roam-mode-map
               ;; Have org-roam-ql's transient available in org-roam-mode buffers
               ("v" . org-roam-ql-buffer-dispatch)
               :map minibuffer-mode-map
               ;; Be able to add titles in queries while in minibuffer.
               ;; This is similar to `org-roam-node-insert', but adds
               ;; only title as a string.
               ("C-c n i" . org-roam-ql-insert-node-title)))
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
