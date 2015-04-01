(asdf:defsystem #:ants
  :depends-on (#:stmx #:bordeaux-threads)
  :components ((:module "src"
                        :components ((:file "package")
                                     (:file "ants"))))
  :in-order-to ((test-op (test-op "ants-test"))))
