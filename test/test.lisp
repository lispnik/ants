(in-package #:ants.test)

(defsuite ants-suite ())

(deftest test-%weighted-random-empty-slices (ants-suite)
  (assert-true (ants::%weighted-random '() 0)))

(deftest test-%weighted-random (ants-suite)
  (assert-equal 0 (ants::%weighted-random '(1 1 1 1) 0))
  (assert-equal 1 (ants::%weighted-random '(1 1 1 1) 1))
  (assert-equal 2 (ants::%weighted-random '(1 1 1 1) 2))
  (assert-equal 3 (ants::%weighted-random '(1 1 1 1) 3)))

(run-suite 'ants-suite)
