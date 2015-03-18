(in-package #:ants.ui)

(defun start ()
  (sdl:with-init ()
    (sdl:window 400 300
                ;:flags sdl-cffi::sdl-opengl
                :resizable t
                :double-buffer t
                :title-caption "Ants"
                :icon-caption "Ants")
    (init)
    (setf (sdl:frame-rate) 60)
    (sdl:with-events ()
      (:quit-event () t)
      (:idle ()
             (main-loop)
             (sdl:update-display)))
    (clean-up)))

(defun init ()
  )

(defun main-loop ()
  )

(defun clean-up ()
  )
