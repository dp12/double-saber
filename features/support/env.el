(require 'f)

(defvar double-saber-support-path
  (f-dirname load-file-name))

(defvar double-saber-features-path
  (f-parent double-saber-support-path))

(defvar double-saber-root-path
  (f-parent double-saber-features-path))

(add-to-list 'load-path double-saber-root-path)

;; Ensure that we don't load old byte-compiled versions
(let ((load-prefer-newer t))
  (require 'double-saber)
  (require 'espuds)
  (require 'ert)
  (require 'grep))

(Setup
 ;; Before anything has run
 )

(Before
 ;; Before each scenario is run
 )

(After
 ;; After each scenario is run
 )

(Teardown
 ;; After when everything has been run
 )
