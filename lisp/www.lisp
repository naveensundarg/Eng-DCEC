;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; www interface ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :eng-dcec)


(defun process-logic-form (x)
  (pipeline 
   x
   (rplcr "\\(all " "(&#8704; ")
   (rplcr "\\(forall " "(&#8704; ")
   (rplcr "\\(exists " "(&#8707; ")
   (rplcr "\\(and " "(&and; ")
   (rplcr "\\(if "  "(&or; ")
   (rplcr "\\(or "  "(&rArr; ")
   (rplcr "\\(k "  "(<b>K </b> ")
   (rplcr "\\(s "  "(<b>S </b> ")
   (rplcr "\\(p "  "(<b>P </b> ")
   (rplcr "\\(b " "(<b>B </b> ")
   (rplcr "(\\b)+i(\\b)+"  " <b>I</b> ")
   (rplcr "(\\b)+tp(\\b)+"  " t<sub><b>p</b></sub>")
   (rplcr "(\\b)+tf(\\b)+"  "  t<sub><b>f</b></sub>")
   (rplcr "\\?[\\w]+"  "?")
   (rplcr "\\?[\\w]+"  "?")
   (rplcr "action1"  "action")
   (rplcr "action2"  "action")
   (rplcr "action1c"  "action")
   (rplcr "action2c"  "action")))

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
                                                 (first trees))) :utf-8)))
        (img-url (concatenate 
                  'string  "<img class='img-responsive' id='abstree' src='"
                  img-ptr "'"
                  ">")))
    (concatenate 'string 
                 "<div class='row'> <div class='col-xs-6 col-md-3
  col-md-offset-5'>   </h5> <a href='"
                 "#" "' onclick= 'return showTree()'"
                 "class='thumbnail'>"  img-url "</a> </div></div>")))

(defun get-tree-for-display (x)
  (+s "<div   class='results' title='DCEC' data-container='body' data-toggle='popover' data-placement='left' data-content='"
   (process-logic-form 
    (string-downcase
     (princ-to-string  (postprocess-tree 
                        (transform-tree x)))))
   "'> " (process-logic-form 
          (string-downcase (princ-to-string (postprocess-tree x))))"</div>"))
(defun pprint-trees (trees)
  (if (null trees) (list "")
      (let ((count 0))
        (append (list 
                 (image-box trees) 
                 "<h4><small> Abstract DCEC semantic representations (mouse
  over for deeper representation)</small></h4><ul class='list-group'>")
                (mapcar 
                 (lambda (x)  
                   (+s
                    "<li class='list-group-item'>"
                    "<span class='badge'>"   
                    (princ-to-string (incf count)) 
                    "</span>"
                    (get-tree-for-display x)
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

(hunchentoot:define-easy-handler (parsegf :uri "/parse") (q)
  (setf (hunchentoot:content-type*) "text/plain")
  (let ((*print-pretty* nil)) 
    (string-downcase (princ-to-string (postprocess-tree  
                                       (transform-tree 
                                        (pre-transform (first (parse (cl-ppcre:regex-replace "%20" q
                                                                                             "\\s"))))))))))

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


(defparameter *server* nil)
(defun start-www (&optional (port 4242))
  (setf *server* (hunchentoot:start (make-instance 'hunchentoot:easy-acceptor
                                                   :port port))))
(defun stop-www () 
  (if *server*
      (progn (hunchentoot:stop *server* :soft nil)
             (setf *server* nil))))



