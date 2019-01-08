;; This file contains your project specific step definitions. All
;; files in this directory whose names end with "-steps.el" will be
;; loaded automatically by Ecukes.

(When "^I call the double-saber-mode-setup for grep$"
      (lambda ()
        (double-saber-mode-setup grep-mode-map 'grep-mode-hook 5 "Grep finished")))

(Then "^inserting \"hello world\" should throw an error"
      (lambda ()
        (should-error (insert "hello world"))))

(When "^I turn off read-only-mode"
      (lambda ()
        (read-only-mode -1)))
