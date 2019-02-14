;; This file contains your project specific step definitions. All
;; files in this directory whose names end with "-steps.el" will be
;; loaded automatically by Ecukes.

(When "^I set up double-saber-mode for grep$"
      (lambda ()
        (add-hook 'grep-mode-hook
                  (lambda ()
                    (double-saber-mode)
                    (setq-local double-saber-start-line 5)
                    (setq-local double-saber-end-text "Grep finished")))))

(Then "^inserting \"hello world\" should throw an error"
      (lambda ()
        (should-error (insert "hello world"))))

(When "^I turn off read-only-mode"
      (lambda ()
        (read-only-mode -1)))
