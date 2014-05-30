(in-package :eng-dcec)

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
      (unwind-protect  (incr) ans)))) 

(defun +s (strings)
  (reduce (lambda (x y) (concatenate 'string x y)) strings :initial-value ""))


