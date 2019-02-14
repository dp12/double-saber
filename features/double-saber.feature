Feature: Delete and narrow in search buffers
  In order to filter out unwanted search output
  As an Emacs user
  I want to delete and narrow in search buffers

  Background:
    Given I switch to buffer "*grep*"
    And I insert:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2343:A redo record for undo-in-region maps to t.
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2393:      (setq undo-in-region
./simple.el.gz:2395:      (if undo-in-region
./simple.el.gz:2409:                                (if undo-in-region " in region" ""))))
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2491:                          (and undo-in-region " for region"))))
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""
    And I set up double-saber-mode for grep
    And I turn on grep-mode


  Scenario: Delete with regexp
    When I start an action chain
    And I press "d"
    And I type "\(setq\|if\)[[:blank:]]undo"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2343:A redo record for undo-in-region maps to t.
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2491:                          (and undo-in-region " for region"))))
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Delete with multiple strings
    When I start an action chain
    And I press "d"
    And I type "redo don't let"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2491:                          (and undo-in-region " for region"))))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Undo delete
    When I press "u"
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2343:A redo record for undo-in-region maps to t.
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2491:                          (and undo-in-region " for region"))))
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Redo after undo
    When I press "C-r"
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2491:                          (and undo-in-region " for region"))))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Undo after redo
    When I press "u"
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2343:A redo record for undo-in-region maps to t.
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2491:                          (and undo-in-region " for region"))))
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Narrow with regexp
    When I start an action chain
    And I press "x"
    And I type "\(defvar\|redo\)"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2343:A redo record for undo-in-region maps to t.
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2481:(defvar undo-in-progress nil

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Undo narrow
    When I press "u"
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2343:A redo record for undo-in-region maps to t.
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2491:                          (and undo-in-region " for region"))))
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Narrow with multiple strings
    When I start an action chain
    And I press "x"
    And I type ";; let nil"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Try to delete header/footer text
    When I start an action chain
    And I press "d"
    And I type "grep Grep finished"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Preserve read-only status
    When I turn on read-only-mode
    And I start an action chain
    And I press "d"
    And I type ";;"
    And I execute the action chain
    Then inserting "hello world" should throw an error
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Preserve read-only off status
    When I turn off read-only-mode
    And I start an action chain
    And I press "x"
    And I type "defvar"
    And I execute the action chain
    And I place the cursor between "at " and "Fri"
    And I insert "hello world "
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at hello world Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2481:(defvar undo-in-progress nil

Grep finished with matches found at Fri Dec 20 00:20:48
"""


  Scenario: Sort lines
    When I turn off read-only-mode
    And the buffer is empty
    And I insert:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2492:  (let ((undo-in-progress t))
./simple.el.gz:2491:                          (and undo-in-region " for region"))))
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2393:      (setq undo-in-region
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2409:                                (if undo-in-region " in region" ""))))
./simple.el.gz:2343:A redo record for undo-in-region maps to t.
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2395:      (if undo-in-region

Grep finished with matches found at Fri Dec 20 00:20:48
"""
    And I turn on grep-mode
    And I start an action chain
    And I press "s"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "/usr/local/share/emacs/26.1/lisp/" -*-
Grep started at Fri Dec 20 00:20:48

zgrep --color -nH -e undo-in simple.el.gz
./simple.el.gz:2343:A redo record for undo-in-region maps to t.
./simple.el.gz:2346:(defvar undo-in-region nil
./simple.el.gz:2393:      (setq undo-in-region
./simple.el.gz:2395:      (if undo-in-region
./simple.el.gz:2409:                                (if undo-in-region " in region" ""))))
./simple.el.gz:2424:    ;; I don't know how to do that in the undo-in-region case.
./simple.el.gz:2433:               (if (or undo-in-region (eq list pending-undo-list))
./simple.el.gz:2481:(defvar undo-in-progress nil
./simple.el.gz:2491:                          (and undo-in-region " for region"))))
./simple.el.gz:2492:  (let ((undo-in-progress t))

Grep finished with matches found at Fri Dec 20 00:20:48
"""