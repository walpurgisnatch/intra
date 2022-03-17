(defsystem "intra-test"
  :defsystem-depends-on ("prove-asdf")
  :author "Walpurgisnatch"
  :license "MIT"
  :depends-on ("intra"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "intra"))))
  :description "Test system for intra"
  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
