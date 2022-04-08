
(defun get-time ()
  (setq current-time-string-split (split-string (current-time-string)))7
  (setq list (delete (elt current-time-string-split 3) current-time-string-split))
  (format "%s" list))

(setq buffers '("j.org" "stasks.org" "reminders.org" "ab.org"))

(add-hook 'org-mode-hook (lambda ()
                           (interactive)
                           (dolist (i buffers)
                             (when (string= (buffer-name) i)
                               (message "buffer: %s" (buffer-name))
                               (shell-command (concat "echo " (get-time) "> f:/emacs/journal/today.txt"))
                               
                               (end-of-buffer)
                               (search-backward "2022)")
                               (beginning-of-line)
                               (setq date-in-journal (buffer-substring-no-properties (+ (line-beginning-position) 2) (line-end-position)))
                               
                               (setq fstring (shell-command-to-string "~/journal/today.txt"))
                               (setq fstring (delete (elt fstring (- (string-width fstring) 0)) fstring))
                               
                               (when (not (string= date-in-journal fstring))
                                 (end-of-buffer)
                                 
                                 (insert fstring)
                                 (org-toggle-heading 1)
                                 (org-return)
                                 (indent-for-tab-command)
                                 
                                 (if (string= (buffer-name) "j.org")
                                     (progn
                                       (insert (concat "\"" "\""))
                                       (org-toggle-heading 2)))

                                 (org-return)
                                 (indent-for-tab-command)
                                 (save-buffer))))))
                           
