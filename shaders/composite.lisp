;;; Combines arbitrary shaders

(in-package :raylisp)

(defclass composite-shader (shader)
  ((shaders :initarg :shaders :accessor shaders-of)))

(defmethod compute-shader-function ((shader composite-shader) object scene transform)
  (let* ((functions (mapcar (lambda (part)
                              (the function (compile-shader part object scene transform)))
			    (shaders-of shader)))
	 (count (float (length functions))))
    (shader-lambda shade-composite (result point normal dot ray counters)
      (declare (optimize speed))
      (let ((tmp (alloc-vec)))
        (declare (dynamic-extent tmp))
        (dolist (fun functions)
         (declare (shader-function fun))
         (%vec+ result result (funcall fun tmp point normal dot ray counters))))
      (%vec/ result result count))))
