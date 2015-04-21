(asdf:defsystem #:ants-test
  :depends-on (#:ants #:clunit)
  :components ((:module "test"
                        :components ((:file "package")
                                     (:file "test")))))

(defmethod perform ((op asdf:test-op) (c (eql (asdf:find-system :ants-test))))
  (funcall (intern "RUN-SUITE" "CLUNIT")
           'ants.test::ants-suite :report-progress nil))
