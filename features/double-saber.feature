Feature: Delete and narrow in search buffers
  In order to filter out unwanted search output
  As an Emacs user
  I want to delete and narrow in search buffers

  Background:
    Given I switch to buffer "*grep*"
    And I insert:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:1:;;; double-saber.el --- Narrow and delete in search buffers.  -*- lexical-binding: t; -*-
double-saber.el:41:  "Clear buffer-read-only and save the original buffer-read-only state."
double-saber.el:42:  (let ((initial-read-only buffer-read-only))
double-saber.el:43:    (buffer-enable-undo)
double-saber.el:48:  "Restore buffer-read-only state based on the READ-ONLY argument given."
double-saber.el:66:          (end-of-buffer))
double-saber.el:67:      (end-of-buffer))
double-saber.el:81:  "Narrow the search buffer output using FILTER.
double-saber.el:96:  "Delete all lines in the buffer using FILTER.
double-saber.el:110:  "Sort lines in the search buffer output.
double-saber.el:146:the search command. If nil, it defaults to the start of the buffer.
double-saber.el:148:END-TEXT should be set to the end text in the buffer that should not be deleted,
double-saber.el:150:buffer."

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""
    And I call the double-saber-mode-setup for grep
    And I turn on grep-mode


  Scenario: Delete with regexp
    When I start an action chain
    And I press "d"
    And I type "buffer-\(read\|enable\)"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:1:;;; double-saber.el --- Narrow and delete in search buffers.  -*- lexical-binding: t; -*-
double-saber.el:66:          (end-of-buffer))
double-saber.el:67:      (end-of-buffer))
double-saber.el:81:  "Narrow the search buffer output using FILTER.
double-saber.el:96:  "Delete all lines in the buffer using FILTER.
double-saber.el:110:  "Sort lines in the search buffer output.
double-saber.el:146:the search command. If nil, it defaults to the start of the buffer.
double-saber.el:148:END-TEXT should be set to the end text in the buffer that should not be deleted,
double-saber.el:150:buffer."

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Delete with multiple strings
    When I start an action chain
    And I press "d"
    And I type "Narrow Delete END-TEXT"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:66:          (end-of-buffer))
double-saber.el:67:      (end-of-buffer))
double-saber.el:110:  "Sort lines in the search buffer output.
double-saber.el:146:the search command. If nil, it defaults to the start of the buffer.
double-saber.el:150:buffer."

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Undo delete
    When I press "u"
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:1:;;; double-saber.el --- Narrow and delete in search buffers.  -*- lexical-binding: t; -*-
double-saber.el:66:          (end-of-buffer))
double-saber.el:67:      (end-of-buffer))
double-saber.el:81:  "Narrow the search buffer output using FILTER.
double-saber.el:96:  "Delete all lines in the buffer using FILTER.
double-saber.el:110:  "Sort lines in the search buffer output.
double-saber.el:146:the search command. If nil, it defaults to the start of the buffer.
double-saber.el:148:END-TEXT should be set to the end text in the buffer that should not be deleted,
double-saber.el:150:buffer."

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Redo after undo
    When I press "C-r"
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:66:          (end-of-buffer))
double-saber.el:67:      (end-of-buffer))
double-saber.el:110:  "Sort lines in the search buffer output.
double-saber.el:146:the search command. If nil, it defaults to the start of the buffer.
double-saber.el:150:buffer."

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Undo after redo
    When I press "u"
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:1:;;; double-saber.el --- Narrow and delete in search buffers.  -*- lexical-binding: t; -*-
double-saber.el:66:          (end-of-buffer))
double-saber.el:67:      (end-of-buffer))
double-saber.el:81:  "Narrow the search buffer output using FILTER.
double-saber.el:96:  "Delete all lines in the buffer using FILTER.
double-saber.el:110:  "Sort lines in the search buffer output.
double-saber.el:146:the search command. If nil, it defaults to the start of the buffer.
double-saber.el:148:END-TEXT should be set to the end text in the buffer that should not be deleted,
double-saber.el:150:buffer."

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Narrow with regexp
    When I start an action chain
    And I press "x"
    And I type "[^D]eleted"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:148:END-TEXT should be set to the end text in the buffer that should not be deleted,

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Undo narrow
    When I press "u"
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:1:;;; double-saber.el --- Narrow and delete in search buffers.  -*- lexical-binding: t; -*-
double-saber.el:66:          (end-of-buffer))
double-saber.el:67:      (end-of-buffer))
double-saber.el:81:  "Narrow the search buffer output using FILTER.
double-saber.el:96:  "Delete all lines in the buffer using FILTER.
double-saber.el:110:  "Sort lines in the search buffer output.
double-saber.el:146:the search command. If nil, it defaults to the start of the buffer.
double-saber.el:148:END-TEXT should be set to the end text in the buffer that should not be deleted,
double-saber.el:150:buffer."

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Narrow with multiple strings
    When I start an action chain
    And I press "x"
    And I type "Narrow Delete Sort"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:1:;;; double-saber.el --- Narrow and delete in search buffers.  -*- lexical-binding: t; -*-
double-saber.el:81:  "Narrow the search buffer output using FILTER.
double-saber.el:96:  "Delete all lines in the buffer using FILTER.
double-saber.el:110:  "Sort lines in the search buffer output.

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Try to delete header/footer text
    When I start an action chain
    And I press "d"
    And I type "grep Grep finished"
    And I execute the action chain
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:1:;;; double-saber.el --- Narrow and delete in search buffers.  -*- lexical-binding: t; -*-
double-saber.el:81:  "Narrow the search buffer output using FILTER.
double-saber.el:96:  "Delete all lines in the buffer using FILTER.
double-saber.el:110:  "Sort lines in the search buffer output.

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Save and restore read-only status
    When I turn on read-only-mode
    And I start an action chain
    And I press "d"
    And I type "Narrow"
    And I execute the action chain
    Then inserting "hello world" should throw an error
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:96:  "Delete all lines in the buffer using FILTER.
double-saber.el:110:  "Sort lines in the search buffer output.

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""


  Scenario: Save and restore read-only off status
    When I turn off read-only-mode
    And I start an action chain
    And I press "x"
    And I type "Sort"
    And I execute the action chain
    And I place the cursor between "at " and "Fri"
    And I insert "hello world "
    Then I should see:
"""
-*- mode: grep; default-directory: "~/double-saber/" -*-
Grep started at hello world Fri Dec 20 00:20:48

grep --color -nH --null -e buffer double-saber.el
double-saber.el:110:  "Sort lines in the search buffer output.

Grep finished with 14 matches found at Fri Dec 20 00:20:48
"""