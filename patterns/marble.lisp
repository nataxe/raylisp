;;;; by Nikodemus Siivola <nikodemus@random-state.net>, 2009.
;;;;
;;;; Permission is hereby granted, free of charge, to any person
;;;; obtaining a copy of this software and associated documentation files
;;;; (the "Software"), to deal in the Software without restriction,
;;;; including without limitation the rights to use, copy, modify, merge,
;;;; publish, distribute, sublicense, and/or sell copies of the Software,
;;;; and to permit persons to whom the Software is furnished to do so,
;;;; subject to the following conditions:
;;;;
;;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;;;; IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
;;;; CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
;;;; TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
;;;; SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(in-package :raylisp)

(defclass marble-pattern (interpolated-pattern axis-mixin)
  ())

(defmethod compute-interpolated-pattern-function ((pattern marble-pattern) transform)
  (let ((inverse (inverse-matrix (matrix* transform (reorient (axis-of pattern) +z+)))))
    (interpolated-pattern-lambda marble-pattern (point)
      (declare (optimize speed))
      (let ((p (transform-point point inverse)))
        (declare (dynamic-extent p))
        (clamp (abs (cos (+ (aref p 0) (turbulence p 0.4 4.0))))
               0.0 1.0)))))
