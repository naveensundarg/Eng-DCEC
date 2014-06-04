
(in-package :eng-dcec)


(defparameter *name-counts* (make-hash-table :test #'equalp))
;; making vars go from t1, t2, x1, x2 etc
(defun get-next-count (table name)
  (if  (gethash name table)
       (incf (gethash name table))
       (setf (gethash name table) 1)))
(defun genvar (root)
  (intern (concatenate 'string root 
                       (princ-to-string (get-next-count *name-counts* root)))))


(Defun pre-transform (x)
  (optima:match x ((list 'S F) (pre-transform F))
                ((cons _ _) (mapcar #'pre-transform x))
                (_ x)))
(defun transform-tree-int (x)
  (optima:match x
    ((list 'and_seq
           (list (or 'happens 'holds) _ t1)
           (list (or 'happens 'holds) _ t2))
     (if (not (equalp t1 t2))
         `(and ,@(rest x) (< x1 x2))))
    ;; present continous
    ((list 'happens (list (or 'action1c 'action2c) ag act) 'now)
     (let ((v (genvar "T")))
       `(and (happens (action ,ag ,act) now) 
             (exists (,v ?) 
                     (happens (action ,ag ,act) ,v)
                     (< now ,v)))))
    ;; simple past
    ((list 'happens (list (or 'action1 'action2) ag act) 'tp)
     (let ((v (genvar "TP")))
       `(exists (,v ?)
         (and (happens (action ,ag ,act) ,v) 
              (< ,v now)))))
    ;; simple future
    ((list 'happens (list (or 'action1 'action2) ag act) 'tf)
     (let ((v (genvar "TF")))
       `(exists (,v ?)
         (and (happens (action ,ag ,act) ,v) 
              (<  now ,v)))))
    ((cons head args) (cons head (mapcar #'transform-tree-int args)))
    (_ (values x (symbol-package x)))))

(defun transform-tree (x)
  (let ((*name-counts* (make-hash-table :test #'equalp)))
    (transform-tree-int x)))

