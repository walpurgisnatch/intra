(defsystem "intra"
  :version "0.1.0"
  :author "Walpurgisnatch"
  :license "MIT"
  :depends-on ("clack"
               "lack"
               "caveman2"
               "envy"
               "cl-ppcre"
               "uiop"
               "cl-syntax-annot"
               "datafly"
               "sxql"
               "mito"
               "cl-pass"
               "jose"
               "local-time")
  :components ((:module "src"
                :components
                ((:file "main" :depends-on ("config" "view" "db"))
                 (:file "utils")
                 (:file "web" :depends-on ("view"))
                 (:file "view" :depends-on ("config"))
                 (:file "db" :depends-on ("config"))
                 (:file "config")))
               (:module "db"
                :components
                ((:file "schema"))))
  :description ""
  :in-order-to ((test-op (test-op "intra-test"))))
