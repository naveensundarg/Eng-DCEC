
(in-package :eng-dcec)


(defparameter *name-counts* (make-hash-table :test #'equalp))
;; making vars go from t1, t2, x1, x2 etc
(defun get-next-count (table name)
  (if  (gethash name table)
       (incf (gethash name table))
       (setf (gethash name table) 1)))
(defun genvar (root)
  (intern (concatenate
           'string root 
           (princ-to-string (get-next-count *name-counts* root)))))


(Defun pre-transform (x)
  (optima:match x ((list 'S F) (pre-transform F))
                ((cons _ _) (mapcar #'pre-transform x))
                (_ x)))



(defparameter *simple-past*
  (list '(list 'happens (list 'action ag act) 'tp)
        '(let ((v (genvar "TP")))
          `(exists (,v ?)
            (and (happens (action ,ag ,act) ,v) 
             (< ,v now))))))

(defparameter *simple-future*
  (list '(list 'happens (list  'action ag act) 'tf)
        '(let ((v (genvar "TF")))
          `(exists (,v ?)
            (and (happens (action ,ag ,act) ,v) 
             (<  now ,v))))))

(defparameter *transforms*
  (list *simple-past* *simple-future*))

(defparameter *test-pats* (list '(1 1) '(2 4)))

;; (deftransform testtransform *test-pats*)
;; (deftransform testtransform2 ((1 1) (2 4)))

(defmacro deftransform (name patterns)
  `(defun ,name (x) (optima:match x ,@(if (symbolp patterns)
                                          (symbol-value patterns)
                                          patterns))))


(defun make-simple-future (ag act)
  (let ((v (genvar "TF")))
    `(exists (,v ?)
             (and (happens (action ,ag ,act) ,v) 
                  (<  now ,v)))))

(defun make-simple-past (ag act)
  (let ((v (genvar "TP")))
       `(exists (,v ?)
         (and (happens (action ,ag ,act) ,v) 
              (< ,v now)))))

(defun transform-tree-int (x)
  (optima:match x
    ((list 'and_seq
           (list (or 'happens 'holds) _ t1)
           (list (or 'happens 'holds) _ t2))
     (if (not (equalp t1 t2))
         `(and ,@(rest x) (< x1 x2))))
    ;; simple past
    ((list 'happens (list 'action ag act) 'tp)
     (make-simple-past ag act))
    ;; simple future
    ((list 'happens (list 'action ag act) 'tf)
     (make-simple-future ag act))
    ((cons head args) (cons head (mapcar #'transform-tree-int args)))
    (_ (values x (symbol-package x)))))

(defun transform-tree (x)
  (let ((*name-counts* (make-hash-table :test #'equalp)))
    (transform-tree-int x)))

;; ;;; some simple tests
;; (use-package :5am)
;; (def-suite transform :description "tests for the transforms")
;; (test test1 
;;  (is (= 3 (+ 2 1))))
