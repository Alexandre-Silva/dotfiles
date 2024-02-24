(require 'doom-start)

(require 'org)
(require 'ox-org)
(require 'icalendar)
(require 'ox-icalendar)

(setq
  org-export-with-broken-links t     ; otherwise it dies on mu4e links
  org-directory (file-name-directory buffer-file-name)
  ; org-agenda-default-appointment-duration 60
  org-export-backends '(icalendar)

  ; org-icalendar-combined-description "Items from Org"
  org-icalendar-combined-name "Ian's Org Calendar"
  ; org-icalendar-combined-agenda-file "org.ics"
  org-icalendar-include-todo t
  ; org-icalendar-store-UID nil
  ; org-icalendar-timezone "Europe/Lisbon"
  org-icalendar-timezone nil

  org-icalendar-use-deadline '(event-if-not-todo todo-due)
  org-icalendar-use-scheduled '(todo-start)
  ; org-icalendar-use-scheduled '(todo-start event-if-todo event-if-not-todo)
  ; org-icalendar-use-scheduled '(event-start)
  ; org-icalendar-use-scheduled '()
  org-icalendar-todo-unscheduled-start nil
  ; org-icalendar-todo-unscheduled-start nil
  org-icalendar-with-timestamps 'active
  ; org-icalendar-use-plain-timestamp nil

  org-icalendar-exclude-tags (list "hide")
  )

(print org-icalendar-use-scheduled)
(print org-icalendar-use-deadline)

;; The real function here asks the operator for confirmation.  Because
;; this is meant to run non-interactively, this hangs the process.
;; This replacement saves unconditionally instead.
(defun org-release-buffers (blist)
  (save-some-buffers t))


(defun replace-file-path-prefix (file-path dir-path output-dir-path)
  "Replace the prefix of FILE-PATH that matches DIR-PATH with OUTPUT-DIR-PATH."
  (let ((relative-path (file-relative-name file-path dir-path)))
    (expand-file-name relative-path output-dir-path)))



(setq export-out-file (replace-file-path-prefix (concat (file-name-sans-extension export-file) ".ics")
                                         org-directory
                                         export-out-dir))

(find-file export-file)
(let ((outfile export-out-file) (org-icalendar-todo-unscheduled-start nil))
  (org-export-to-file 'icalendar outfile
    nil nil nil nil nil
    ))


;; The nil argument means do it synchronously instead of async.
; (org-icalendar-combine-agenda-files nil)


 ;; Personal calendar -- no verbose school entries
; (setq
;  org-icalendar-exclude-tags (list "verbose")
;  org-icalendar-combined-name "Ian's Plain Org Calendar"
;  org-icalendar-combined-agenda-file "plain.ics")
;
; (org-icalendar-combine-agenda-files nil)

 ;; School, detailed, one .ics per .org
; (setq
;  org-export-select-tags nil
;  org-icalendar-exclude-tags nil
;  org-icalendar-combined-name "School 2019-20"
;  org-icalendar-combined-description "Important dates for the school year"
;  org-agenda-files (list "school/2019.org")
;  org-icalendar-combined-agenda-file "school.ics")

; (org-icalendar-combine-agenda-files nil)
