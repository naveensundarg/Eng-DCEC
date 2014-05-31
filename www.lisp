;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; www interface ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :eng-dcec)

(defun process-logic-form (x)
  (pipeline 
   x
   (lambda (x) (cl-ppcre:regex-replace-all "\\(and " x "(&and; "))
   (lambda (x) (cl-ppcre:regex-replace-all "\\(if " x "(&or; "))
   (lambda (x) (cl-ppcre:regex-replace-all "\\(or " x "(&rArr; "))
   (lambda (x) (cl-ppcre:regex-replace-all "\\(k " x "(<b>K </b> "))
   (lambda (x) (cl-ppcre:regex-replace-all "\\(s " x "(<b>S </b> "))
   (lambda (x) (cl-ppcre:regex-replace-all "\\(p " x "(<b>P </b> "))
   (lambda (x) (cl-ppcre:regex-replace-all "\\(b " x "(<b>B </b> "))
   (lambda (x) (cl-ppcre:regex-replace-all "(\\b)+i(\\b)+" x " <b>I</b> "))
   (lambda (x) (cl-ppcre:regex-replace-all "(\\b)+tp(\\b)+" x " t<sub><b>p</b></sub>"))
   (lambda (x) (cl-ppcre:regex-replace-all "(\\b)+tf(\\b)+" x "
  t<sub><b>f</b></sub>"))
   (lambda (x) (cl-ppcre:regex-replace-all "\\?[\\w]+" x "?"))))

(defparameter *success-message* "<br/><span class='label label-success'>Parsed</span>")
(defparameter *incomplete-message* "<br/><span class='label label-warning'>incomplete</span>")
(defparameter *waiting-message* "<br/><span class='label
label-default'>waiting</span>") 
(defparameter *oops-message* "<br/><span class='label label-danger'>oops</span>") 

(defun pipeline (x &rest funcs)
  (reduce (lambda (val func) (funcall func val)) funcs :initial-value x))


 
(defun postprocess-tree (tree)
  (if (symbolp tree) 
      (remap-symbols tree)
      (optima:match tree
        ((list 's u) (postprocess-tree u))
        ((list (or 'i1now 'i2now) agent time action)
         `(intends ,agent ,time (happens ,action now)))
        ((list (or 'i1later 'i2later) agent time action)
         `(intends ,agent ,time (happens ,action tf)))
        ((cons head rest) (cons  head  (mapcar #'postprocess-tree rest)))
        (_ tree))))
(defun image-box (trees)
  (let* ((img-ptr (concatenate 'string
                              *gf-server-url*
                              "abstrtree&tree=" 
                              (drakma:url-encode 
                               (string-downcase (princ-to-string
                                                 (first
                                                  trees))) :utf-8)))
        (img-url (concatenate 
                  'string  "<img id='abstree' src='"
                  img-ptr "'"
                  ">")))
    (concatenate 'string 
                 "<div class='row'> <div class='col-xs-6 col-md-3 col-md-offset-5'> <a href='"
                 "#" "' onclick= 'return showTree()'"
                 "class='thumbnail'>" img-url "</a> </div></div>")))
(defun pprint-trees (trees)
  (if (null trees) (list "")
      (let ((count 0))
        (append (list (image-box trees) "<ul class='list-group'>")
                (mapcar (lambda (x)  
                          (concatenate 'string
                                       "<li class='list-group-item'>"
                                       "<span class='badge'>"   
                                       (princ-to-string (incf count)) 
                                       "</span>"
                                       (process-logic-form 
                                        (string-downcase
                                         (princ-to-string  (postprocess-tree x))))
                                       "</li>"))
                        trees)
                (list "</ul>" )))))

(defun highlight-word (str words)
  (if (cl-ppcre:scan (concatenate 'string (first words) "\\b") str)
      (cons (concatenate 'string "<font color='gray'>"(first words) "</font>") (rest words))
      words))
(defun iparse-full (str)
  (unwind-protect 
       (let* 
           ((words (complete str))
            (completions (set-difference
                          (complete (concatenate 'string str " ")) 
                          words :test #'equalp)))
                    (concatenate 'string 
                                 "<div class='panel panel-default'>"
                                 "<div class='panel-body'>"
                                 ;(if (not (= 1 (length word))))
                                 
                                 (format nil "~{~a~^, ~} " 
                                         (append  (highlight-word str words) completions))
                                 ;(format nil "~{~a~^, ~} "  completions)  

                                 "</div>"
                                 "</div>"
                                 (+s
                                  (let* ((trees (parse str))
                                         (msg (if trees  
                                                  *success-message*
                                                  (if  completions
                                                       *incomplete-message*
                                                       (if words  
                                                           *waiting-message*
                                                          *oops-message*)))))
                                    (append (pprint-trees trees)
                                            (list msg))))))
    (list "")))


(hunchentoot:define-easy-handler (query :uri "/query") (q)
  (setf (hunchentoot:content-type*) "text/plain")
  (iparse-full (cl-ppcre:regex-replace "%20" q
                                       "\\s")))

(defun surround-by-parens (str) (concatenate 'string "(" str ")"))
(hunchentoot:define-easy-handler (randomgf :uri "/randomgf") ()
  (setf (hunchentoot:content-type*) "text/plain")
  (surround-by-parens (first (random-gf))))

(defun scoreSentence (x y)
  (let ((ground (linearize y))) (princ-to-string 
                                 (/ (abs (- (levenshtein:DISTANCE 
                                             (cl-ppcre:regex-replace-all "%20" x "\\s")
                                             ground)
                                            (length ground)))
                                    (length ground)))))
(hunchentoot:define-easy-handler (computeScore :uri "/computeScore") (x y)
  (setf (hunchentoot:content-type*) "text/plain")
  (scoreSentence x y))

(push 
 (hunchentoot:create-folder-dispatcher-and-handler 
  "/core/" *core-dir*) 
 hunchentoot:*dispatch-table*)


(defun start-www (&optional (port 4242))
  (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor :port port)))