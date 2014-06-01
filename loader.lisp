
(defparameter *ql-modules*
  (list "drakma"
        "optima"
        "cl-fad"
        "yason"
        "cl-ppcre"
        "hunchentoot"
        "Levenshtein"))



(mapcar #'quicklisp:quickload *ql-modules*)
(defparameter *reports* ())


(defparameter *files*
  (list
   "packages"
   "configs"
   "utils"
   "interface"
   "transform"
   "www")) 

(defun compile-and-load (pathname &key (verbose nil))
  (multiple-value-bind (output-pathname warnings-p failure-p)
      (compile-file 
       (merge-pathnames 
        pathname (load-time-value *load-truename*)) :verbose verbose)
    (declare (ignore warnings-p))
    (if failure-p
	(error "Could not compile ~a" pathname)
	(load output-pathname))))


(map nil 'compile-and-load *files*)

