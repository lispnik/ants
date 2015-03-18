(in-package #:ants)

;;; (ql:quickload "stmx")

(transactional
 (defclass cell ()
   ((food :initform 0)
    (pheromone :initform 0)
    (home :initform nil)
    (ant :initform nil))))

(defvar dim 80)
(defvar nants-sqrt 7)
(defvar food-places 35)
(defvar food-range 100)
(defvar evap-rate 0.99)

(defvar home-off (/ dim 4))
(defvar home-range nants-sqrt)

(defvar world
  (make-array (list dim dim)
              :element-type 'cell
              :initial-contents (loop repeat dim
                                   collect (loop repeat dim collect (make-instance 'cell)))))

(defun place (location)
  (with-slots (x y) location
    (aref x y world)))

(transactional
 (defclass ant ()
   ((direction :initarg direction :initform (random 8))
    (food))))

(defclass v ()
  ((x :type integer :initarg :x)
   (y :type integer :initarg :y)))

(defun v (x y) (make-instance 'v :x x :y y))

(defmethod print-object ((object v) stream)
  (print-unreadable-object (object stream :type t)
    (with-slots (x y) object
      (format stream "~A,~A" x y))))

(defun setup ()
  (atomic
   (loop repeat food-places
      do (setf (slot-value (aref world (random dim) (random dim)) 'food)
               (random food-range)))
   (loop for x from home-off below (+ home-range home-off)
      for y from home-off below (+ home-range home-off)
      do (setf (slot-value (aref world x y) 'home) t)
      collecting (make-instance 'ant :location (v x y)))))

(defun bound (b n)
  (let ((n (mod n b)))
    (if (minusp n)
        (+ n b)
        n)))

(defvar direction-delta
  '#((v 0 -1) (v 1 -1) (v 1 0) (v 1 1) (v 0 1) (v -1 1) (v -1 0) (v -1 -1)))

(defun delta-location (location direction)
  (with-slots (x y) location
    (with-slots ((dx x) (dy y)) (aref direction direction-delta)
      (v (bound dim (+ x dx))
         (bound dim (+ y dy))))))

(defun turn (location amount)
  (atomic
   (let* ((place (place location))
          (ant (slot-value place 'ant)))
     (setf (slot-value ant 'direction)
           (bound 8 (+ (slot-value ant 'direction) amount))))
   location))

(defun move (location)
  (atomic
   (let* ((place (place location))
          (ant (slot-value place 'ant))
          (new-location (delta-location location (slot-value ant 'direction)))
          (new-place (place new-location)))
     (setf (slot-value ant 'location) new-location)
     (setf (slot-value place 'ant) nil)
     (setf (slot-value new-place 'ant) ant)
     (unless (slot-value place 'home)
       (incf (slot-value place 'pheromone)))
     new-location)))

(defun take-food (location)
  (atomic
   (let* ((place (place location))
          (ant (slot-value place 'ant)))
     (decf (slot-value place 'food))
     (setf (slot-value ant 'food) t)
     (setf (slot-value place 'ant) ant))
   location))

(defun drop-food (location)
  (atomic
   (let* ((place (place location))
          (ant (slot-value place 'ant)))
     (incf (slot-value place 'food))
     (setf (slot-value ant 'food) nil)
     (setf (slot-value place 'ant) ant))
   location))

(defun behave (location)
  (atomic
   (let* ((place (place location))
          (ant (slot-value place 'ant)))
     (with-slots (direction) ant
       (let ((ahead (place (delta-location location direction)))
             (ahead-left (place (delta-location location (1+ direction))))
             (ahead-right (place (delta-location location (1- direction)))))
         (if (slot-value ant 'food)
             (cond ((slot-value ant 'home)
                    (drop-food location)
                    (turn location 4))
                   ((and (slot-value ahead 'home)
                         (not (slot-value ahead 'ant)))
                    (move location))
                   (t (let ((ranks #|...|# nil))
                        ;; TODO
                        location)))
             (cond ((and (plusp (slot-value place 'food))
                         (not (slot-value place 'home)))
                    (take-food location)
                    (turn location 4)
                    ;; TODO
                    )
                   ((and (plusp (slot-value ahead 'food))
                         (not (slot-value 'ahead 'home))
                         (not (slot-value 'ahead 'ant)))
                    ;; TODO
                    )
                   (t (let ((ranks #|...|# nil))
                        ;; TODO
                        location)))))))))

(defun evaporate ()
  (atomic
   (loop for x from 0 below dim
      for y from 0 below dim
      do (setf (slot-value (aref world x y) 'pheromone)
               (* evap-rate (slot-value (aref world x y) 'pheromone))))))
