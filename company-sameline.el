;;; company-sameline.el --- company-mode completion with previous whole lines  -*- lexical-binding: t -*-

;; Copyright (C) 2018 Johannes Rohrer

;; Author: Johannes Rohrer <src@johannesrohrer.de>
;; Created: 2018-04-11
;; Package-Requires: ((emacs "25.1") (company "0.9.6")
;; Keywords: abbrev, completion, convenience
;; Homepage: https://github.com/johannesrohrer/company-sameline

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 3 of the Licence,
;; or (at your option) any later version.

;; This file is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file; see the file COPYING. If not, see
;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Simple line completion backend for ‘company-mode’. Completion
;; candidates are whole lines from above point in the current buffer.
;;
;; To set it up, load this package and add ‘company-sameline’ to
;; ‘company-backends’. To activate it, set ‘company-sameline-active’
;; to t, for example using a file-local variable.

;;; Code:

(require 'company)
(eval-when-compile (require 'cl-lib))


(defgroup company-sameline nil
  "Company mode backend for previous whole buffer lines."
  :group 'company
  :prefix "company-sameline-")

(defcustom company-sameline-active nil
  "Non-nil value activates ‘company-sameline’ completion backend."
  :type 'boolean
  :safe #'booleanp)

(make-variable-buffer-local 'company-sameline-active)


(defun company-sameline--previous-lines-starting-with (linepart)
  (let ((buf (current-buffer))
        (beg (point-min))
        (lbp (line-beginning-position)))
    (with-temp-buffer
      (insert-buffer-substring-no-properties buf beg lbp)
      (keep-lines (concat "^" (regexp-quote linepart))
                  (point-min)
                  (point-max))
      (reverse-region (point-min) (point-max))
      (delete-duplicate-lines (point-min) (point-max))
      (split-string (buffer-string) "\n" t))))

;;;###autoload
(defun company-sameline (command &optional arg &rest _ignored)
  "‘company-mode’ completion backend for previous whole buffer lines.
With point at the end of a line containing at least one
non-whitespace character, offer for completion any line above
point in the current buffer that starts like the current one.

To activate it, set the variable ‘company-sameline-active’ to
a non-nil value, possibly in a file local variable."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-sameline-backend))
    (prefix
     (if (and company-sameline-active
              (eolp)
              (looking-back "\\S-\\s-*" (line-beginning-position)))
         (buffer-substring-no-properties (line-beginning-position)
                                         (line-end-position))))
    (candidates (company-sameline--previous-lines-starting-with arg))
    (sorted t)))

(provide 'company-sameline)
;;; company-sameline.el ends here
