(asdf:defsystem #:ants-test
  :depends-on (#:ants #:clunit)
  :components ((:module "test"
                        :components ((:file "package")
                                     (:file "test")))))
