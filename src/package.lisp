(defpackage #:ants
  (:export #:behave)
  (:use #:common-lisp
        #:stmx
        #:bordeaux-threads))

(defpackage #:ants.ui
  (:use #:common-lisp
        #:ants
        #:stmx))
