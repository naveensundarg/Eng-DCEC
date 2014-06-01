(in-package :eng-dcec)

;; less verbose string concatenation
(defun +s (&rest args)
  (labels ((+s-int (strings)
            (reduce (lambda (x y)
                      (concatenate 'string x y)) 
                    strings :initial-value "")))
    (cond ((and (listp (first args)) (= 1 (length args))) (+s-int (first args)))
          (t (+s-int args)))))

(defun rplcr (pat  with)
  (lambda (x) (cl-ppcre:regex-replace-all pat x with)))

(defun rplc (pat str with)
  (apply (rplcr pat with) str))

(defun remap-symbols (sym)
  (optima:match sym 
    (_ sym)))
