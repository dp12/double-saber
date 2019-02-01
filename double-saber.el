;;; double-saber.el --- Narrow and delete in search buffers.  -*- lexical-binding: t; -*-

;; Author: Daniel Ting <deep.paren.12@gmail.com>
;; URL: https://github.com/dp12/double-saber.git
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.4"))
;; Keywords: double-saber, narrow, delete, sort, tools, convenience, matching

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; To load this file, add (require 'double-saber) to your init file.
;;
;; You can configure double-saber for different modes using
;; double-saber-mode-setup. The following are a few examples.
;;
;; (double-saber-mode-setup grep-mode-map 'grep-mode-hook 5 "Grep finished")
;; (double-saber-mode-setup ggtags-global-mode-map 'ggtags-global-mode-hook 5 "Global found")
;; (double-saber-mode-setup ripgrep-search-mode-map 'ripgrep-search-mode-hook 5 "Ripgrep finished")
;; (double-saber-mode-setup ivy-occur-grep-mode-map 'ivy-occur-grep-mode-hook 5 nil)
;;
;; (add-hook 'ripgrep-search-mode-hook
          ;; (lambda ()
            ;; (double-saber-mode)
            ;; (setq-local double-saber-start-line 5)
            ;; (setq-local double-saber-end-text "Ripgrep finished")))

;;; Code:
(require 'subr-x) ;; for string-trim

(defvar double-saber-start-line 5)
(defvar double-saber-end-text nil)

;;;
;;; Private functions
;;;
(defun double-saber--start-point ()
  "Determine the start point of the region to act on."
  (save-excursion
    (if double-saber-start-line
      (with-no-warnings
        (goto-line double-saber-start-line))
      (goto-char (point-min)))
    (point)))

(defun double-saber--end-point ()
  "Determine the end point of the region to act on."
  (save-excursion
    (goto-char (point-min))
    (if double-saber-end-text
        (if (search-forward double-saber-end-text nil t)
            (forward-line -1)
          (goto-char (point-max)))
      (goto-char (point-max)))
    (point)))

(defun double-saber--get-regexp (filter)
  "Form a regular expression from FILTER.
If the input consists of multiple strings, use regex-opt to make a regular
expression that matches them. Otherwise, if the input is a single string with no
spaces, return it unchanged as the regular expression."
  (let ((regexp (split-string (string-trim filter) " ")))
    (if (> (length regexp) 1)
        (regexp-opt regexp)
      (car regexp))))

;;;
;;; Public functions
;;;
(defun double-saber-narrow (&optional filter)
  "Narrow the search buffer output using FILTER.
The filter can either be a regular expression with no spaces or a list of
strings. All lines that do not match the regular expression or one of the
strings is deleted."
  (interactive
   (list (read-string "Narrow regex/strings: ")))
  (let ((inhibit-read-only t))
    (buffer-enable-undo)
    (delete-non-matching-lines (double-saber--get-regexp filter)
                               (double-saber--start-point)
                               (double-saber--end-point))))

(defun double-saber-delete (&optional filter)
  "Delete all lines in the buffer using FILTER.
The filter can either be a regular expression with no spaces or a list of
strings. All lines that match the regular expression or one of the strings is
deleted."
  (interactive
   (list (read-string "Delete regex/strings: ")))
  (let ((inhibit-read-only t))
    (buffer-enable-undo)
    (delete-matching-lines (double-saber--get-regexp filter)
                           (double-saber--start-point)
                           (double-saber--end-point))))

(defun double-saber-sort-lines (&optional reverse)
  "Sort lines in the search buffer output.
If the REVERSE flag is true, the lines are sorted in reverse order."
  (interactive)
  (let ((inhibit-read-only t))
    (buffer-enable-undo)
    (sort-lines reverse (double-saber--start-point) (double-saber--end-point))))

(defun double-saber-undo (&optional arg)
  "Undo changes. An optional numeric ARG serves as a repeat count."
  (interactive "P")
  (let ((inhibit-read-only t))
    (if (fboundp 'undo-tree-undo)
        (undo-tree-undo arg)
      (undo arg))))

(defun double-saber-redo (&optional arg)
  "Redo changes. An optional numeric ARG serves as a repeat count."
  (interactive "P")
  (let ((inhibit-read-only t))
    (if (fboundp 'undo-tree-redo)
        (undo-tree-redo arg)
      (undo arg))))

;; Mode-specific setup
(defun double-saber-mode-setup (keymap hook &optional start-line end-text)
  "Set up double-saber default keybindings and start/end bounds for a mode.
KEYMAP is the keymap of the major mode to configure.
HOOK is the mode hook of the major mode to configure. The HOOK argument must be
quoted.

START-LINE should be set to the line after the search command, to avoid deleting
the search command. If nil, it defaults to the start of the buffer.

END-TEXT should be set to the end text in the buffer that should not be deleted,
e.g. a string such as 'Search finished.' If nil, it defaults to the end of the
buffer."
  (define-key keymap (kbd "d") 'double-saber-delete)
  (define-key keymap (kbd "x") 'double-saber-narrow)
  (define-key keymap (kbd "s") 'double-saber-sort-lines)
  (define-key keymap (kbd "u") 'double-saber-undo)
  (define-key keymap (kbd "C-r") 'double-saber-redo)
  (define-key keymap (kbd "C-_") 'double-saber-redo)
  (add-hook hook
            (lambda ()
              (setq-local double-saber-start-line start-line)
              (setq-local double-saber-end-text end-text))))

(provide 'double-saber)

;;; double-saber.el ends here
