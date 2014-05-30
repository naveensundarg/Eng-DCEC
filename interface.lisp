(ql:quickload :drakma)
(ql:quickload "yason")
(ql:quickload "cl-ppcre")
(ql:quickload "hunchentoot")
(ql:quickload "Levenshtein")
(defparameter *gf-server-url* "http://localhost:41296/DCEC.pgf?command=")

(defparameter *parse-stream* nil)
(defparameter *complete-stream* nil)

(defun parse (str)
  (let* ((uri (concatenate 'string *gf-server-url*
                           "parse&input="
                           (cl-ppcre:regex-replace-all "\\s" str "%20"))) 
         (stream 
           (drakma:http-request 
            uri
            :want-stream t )))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (let ((obj (first (yason:parse stream))))
      (close stream)
      (mapcar (lambda (x)
                (read-from-string
                 (concatenate 'string "(" x ")"))) 
              (gethash "trees" obj)))))



(defun random-gf ()
  (let* ((uri (concatenate 'string *gf-server-url*
                               "random"))
         (stream 
           (drakma:http-request 
            uri
            :want-stream t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (let ((obj (first (yason:parse stream))))
      (close stream)
       (list (gethash "tree" obj)
            (gethash "texts" (first (gethash "linearizations" obj)))))))
(defun complete (str)
  (let* ((uri (concatenate 'string *gf-server-url*
                               "complete&input="
                               (cl-ppcre:regex-replace-all "\\s" str "%20")))
         (stream 
           (drakma:http-request 
            uri
            :want-stream t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (let ((obj (first (yason:parse stream))))
      (close stream)
      (gethash "completions" obj))))




(defun linearize (str)
  (let* ((url  (concatenate 'string
                            *gf-server-url*
                            "linearize&tree="
                            (drakma:url-encode
                             str :LATIN-1)))
         (stream (drakma:http-request 
                  url :method :get
                  :want-stream t :preserve-uri t :close t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (let ((obj (first (yason:parse stream))))
      (close stream)
      (gethash "text" obj))))


(defun prompt-read (prompt)
  (format *query-io* "~%~%Parse: ~a" prompt)
  (force-output *query-io*)
  (read-line *query-io*))

(defun iparse ()
	   (let ((ans nil)
                 (buffer ""))
	     (labels ((incr () 
			(let ((chunk (prompt-read buffer)))

			  (setf buffer (concatenate 'string buffer chunk))
 			  (let ((parsed (parse buffer)))
			    (if  parsed (progn (print parsed) 
                                               (print (complete buffer))
                                               (setf ans parsed)
                                               (if (equalp "!" chunk)  ans (incr)))
				(progn (print (complete buffer)) 
                                       (if (equalp "!" chunk) ans  (incr))))))))
               (unwind-protect  (incr)
                      ans)))) 

(defun +s (strings)
	   (reduce (lambda (x y) (concatenate 'string x y)) strings :initial-value ""))


;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; www interface ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;
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
   (lambda (x) (cl-ppcre:regex-replace-all "(\\b)+tf(\\b)+" x " t<sub><b>f</b></sub>"))))

(defparameter *success-message* "<br/><span class='label label-success'>Parsed</span>")
(defparameter *incomplete-message* "<br/><span class='label label-warning'>incomplete</span>")
(defparameter *waiting-message* "<br/><span class='label
label-default'>waiting</span>") 
(defparameter *oops-message* "<br/><span class='label label-danger'>oops</span>") 

(defun pipeline (x &rest funcs)
  (reduce (lambda (val func) (funcall func val)) funcs :initial-value x))

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
                                       (process-logic-form (string-downcase  (princ-to-string x)))
                                       "</li>"))
                        trees)
                (list "</ul>" )))))

(defun iparse-full (str)
  (unwind-protect 
       (let* 
           ((word (complete str))
            (completions (set-difference
                          (complete (concatenate 'string str " ")) 
                          word :test #'equalp)))
                    (concatenate 'string 
                                 "<div class='panel panel-default'>"
                                 "<div class='panel-body'>"
                                 (if (not completions)  (format nil "~{~a~^, ~} " word))
                                 (format nil "~{~a~^, ~} " completions)  

                                 "</div>"
                                 "</div>"
                                 (+s
                                  (let* ((trees (parse str))
                                         (msg (if trees  
                                                  *success-message*
                                                  (if  completions
                                                       *incomplete-message*
                                                       (if word  
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
(hunchentoot:define-easy-handler (randomgf :uri "/randomgf") (q)
  (setf (hunchentoot:content-type*) "text/plain")
  (surround-by-parens (first (random-gf))))

(hunchentoot:define-easy-handler (computeScore :uri "/computeScore") (x y)
  (setf (hunchentoot:content-type*) "text/plain")
  (princ-to-string (levenshtein:DISTANCE (cl-ppcre:regex-replace-all "%20" x "\\s")
                                         (linearize y))))

(push 
 (hunchentoot:create-folder-dispatcher-and-handler 
  "/core/" #p"/Users/naveen/work/Eng-DCEC/") 
 hunchentoot:*dispatch-table*)

