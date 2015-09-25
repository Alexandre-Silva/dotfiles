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
      (defun bh/find-project-task ()
        "Move point to the parent (project) task if any"
        (save-restriction
          (widen)
          (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
            (while (org-up-heading-safe)
              (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
                (setq parent-task (point))))
            (goto-char parent-task)
            parent-task)))

      (defun bh/is-project-p ()
        "Any task with a todo keyword subtask"
        (save-restriction
          (widen)
          (let ((has-subtask)
                (subtree-end (save-excursion (org-end-of-subtree t)))
                (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
            (save-excursion
              (forward-line 1)
              (while (and (not has-subtask)
                          (< (point) subtree-end)
                          (re-search-forward "^\*+ " subtree-end t))
                (when (member (org-get-todo-state) org-todo-keywords-1)
                  (setq has-subtask t))))
            (and is-a-task has-subtask))))

      (defun bh/is-project-subtree-p ()
        "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
        (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                                    (point))))
          (save-excursion
            (bh/find-project-task)
            (if (equal (point) task)
                nil
              t))))

      (defun bh/is-task-p ()
        "Any task with a todo keyword and no subtask"
        (save-restriction
          (widen)
          (let ((has-subtask)
                (subtree-end (save-excursion (org-end-of-subtree t)))
                (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
            (save-excursion
              (forward-line 1)
              (while (and (not has-subtask)
                          (< (point) subtree-end)
                          (re-search-forward "^\*+ " subtree-end t))
                (when (member (org-get-todo-state) org-todo-keywords-1)
                  (setq has-subtask t))))
            (and is-a-task (not has-subtask)))))

      (defun bh/is-subproject-p ()
        "Any task which is a subtask of another project"
        (let ((is-subproject)
              (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
          (save-excursion
            (while (and (not is-subproject) (org-up-heading-safe))
              (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
                (setq is-subproject t))))
          (and is-a-task is-subproject)))

      (defun bh/list-sublevels-for-projects-indented ()
        "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
        (if (marker-buffer org-agenda-restrict-begin)
            (setq org-tags-match-list-sublevels 'indented)
          (setq org-tags-match-list-sublevels nil))
        nil)

      (defun bh/list-sublevels-for-projects ()
        "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
        (if (marker-buffer org-agenda-restrict-begin)
            (setq org-tags-match-list-sublevels t)
          (setq org-tags-match-list-sublevels nil))
        nil)

      (defvar bh/hide-scheduled-and-waiting-next-tasks t)

      (defun bh/toggle-next-task-display ()
        (interactive)
        (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
        (when  (equal major-mode 'org-agenda-mode)
          (org-agenda-redo))
        (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

      (defun bh/skip-stuck-projects ()
        "Skip trees that are not stuck projects"
        (save-restriction
          (widen)
          (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (if (bh/is-project-p)
                (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                       (has-next ))
                  (save-excursion
                    (forward-line 1)
                    (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                      (unless (member "WAITING" (org-get-tags-at))
                        (setq has-next t))))
                  (if has-next
                      nil
                    next-headline)) ; a stuck project, has subtasks but no next task
              nil))))

      (defun bh/skip-non-stuck-projects ()
        "Skip trees that are not stuck projects"
        ;; (bh/list-sublevels-for-projects-indented)
        (save-restriction
          (widen)
          (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (if (bh/is-project-p)
                (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                       (has-next ))
                  (save-excursion
                    (forward-line 1)
                    (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                      (unless (member "WAITING" (org-get-tags-at))
                        (setq has-next t))))
                  (if has-next
                      next-headline
                    nil)) ; a stuck project, has subtasks but no next task
              next-headline))))

      (defun bh/skip-non-projects ()
        "Skip trees that are not projects"
        ;; (bh/list-sublevels-for-projects-indented)
        (if (save-excursion (bh/skip-non-stuck-projects))
            (save-restriction
              (widen)
              (let ((subtree-end (save-excursion (org-end-of-subtree t))))
                (cond
                 ((bh/is-project-p)
                  nil)
                 ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
                  nil)
                 (t
                  subtree-end))))
          (save-excursion (org-end-of-subtree t))))

      (defun bh/skip-non-tasks ()
        "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
        (save-restriction
          (widen)
          (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (cond
             ((bh/is-task-p)
              nil)
             (t
              next-headline)))))

      (defun bh/skip-project-trees-and-habits ()
        "Skip trees that are projects"
        (save-restriction
          (widen)
          (let ((subtree-end (save-excursion (org-end-of-subtree t))))
            (cond
             ((bh/is-project-p)
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-projects-and-habits-and-single-tasks ()
        "Skip trees that are projects, tasks that are habits, single non-project tasks"
        (save-restriction
          (widen)
          (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (cond
             ((and bh/hide-scheduled-and-waiting-next-tasks
                   (member "WAITING" (org-get-tags-at)))
              next-headline)
             ((bh/is-project-p)
              next-headline)
             ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
              next-headline)
             (t
              nil)))))

      (defun bh/skip-project-tasks-maybe ()
        "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
        (save-restriction
          (widen)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (next-headline (save-excursion (or (outline-next-heading) (point-max))))
                 (limit-to-project (marker-buffer org-agenda-restrict-begin)))
            (cond
             ((bh/is-project-p)
              next-headline)
             ((and (not limit-to-project)
                   (bh/is-project-subtree-p))
              subtree-end)
             ((and limit-to-project
                   (bh/is-project-subtree-p)
                   (member (org-get-todo-state) (list "NEXT")))
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-project-tasks ()
        "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
        (save-restriction
          (widen)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
            (cond
             ((bh/is-project-p)
              subtree-end)
             ((bh/is-project-subtree-p)
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-non-project-tasks ()
        "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
        (save-restriction
          (widen)
          (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                 (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
            (cond
             ((bh/is-project-p)
              next-headline)
             ((and (bh/is-project-subtree-p)
                   (member (org-get-todo-state) (list "NEXT")))
              subtree-end)
             ((not (bh/is-project-subtree-p))
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-projects-and-habits ()
        "Skip trees that are projects and tasks that are habits"
        (save-restriction
          (widen)
          (let ((subtree-end (save-excursion (org-end-of-subtree t))))
            (cond
             ((bh/is-project-p)
              subtree-end)
             (t
              nil)))))

      (defun bh/skip-non-subprojects ()
        "Skip trees that are not projects"
        (let ((next-headline (save-excursion (outline-next-heading))))
          (if (bh/is-subproject-p)
              nil
            next-headline)))



      ;; Custom agenda command definitions
      (setq org-agenda-custom-commands
            (quote (("N" "Notes" tags "NOTE"
                     ((org-agenda-overriding-header "Notes")
                      (org-tags-match-list-sublevels t)))
                    ("h" "Habits" tags-todo "STYLE=\"habit\""
                     ((org-agenda-overriding-header "Habits")
                      (org-agenda-sorting-strategy
                       '(todo-state-down effort-up category-keep))))
                    ("." "Agenda"
                     ((agenda "" nil)
                      (tags "REFILE"
                            ((org-agenda-overriding-header "Tasks to Refile")
                             (org-tags-match-list-sublevels nil)))
                      (tags-todo "-CANCELLED/!"
                                 ((org-agenda-overriding-header "Stuck Projects")
                                  (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-HOLD-CANCELLED/!"
                                 ((org-agenda-overriding-header "Projects")
                                  (org-agenda-skip-function 'bh/skip-non-projects)
                                  (org-tags-match-list-sublevels 'indented)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-CANCELLED/!NEXT"
                                 ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                                  (org-tags-match-list-sublevels t)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(todo-state-down effort-up category-keep))))
                      (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                                 ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-non-project-tasks)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                                 ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-project-tasks)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-sorting-strategy
                                   '(category-keep))))
                      (tags-todo "-CANCELLED+WAITING|HOLD/!"
                                 ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                        (if bh/hide-scheduled-and-waiting-next-tasks
                                                                            ""
                                                                          " (including WAITING and SCHEDULED tasks)")))
                                  (org-agenda-skip-function 'bh/skip-non-tasks)
                                  (org-tags-match-list-sublevels nil)
                                  (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                                  (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                      (tags "-REFILE/"
                            ((org-agenda-overriding-header "Tasks to Archive")
                             (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                             (org-tags-match-list-sublevels nil))))
                     nil))))


      ;; Refile settings
      ;; Exclude DONE state tasks from refile targets
      (defun bh/verify-refile-target ()
        "Exclude todo keywords with a done state from refile targets"
        (not (member (nth 2 (org-heading-components)) org-done-keywords)))
      )
    )
  )

