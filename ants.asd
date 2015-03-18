(asdf:defsystem #:ants
  :serial t
  :components ((:file "packages")
               (:file "ants")
               (:file "ui"))
  :depends-on (#:stmx
               #:bordeaux-threads
               #:clinch-sdl
               #:clinch))
