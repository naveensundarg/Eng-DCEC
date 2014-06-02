(in-package :eng-dcec)



(defun talk-to-gf-server (command)
  (let* ((uri (+s *gf-server-url* command)) 
         (stream 
          (drakma:http-request 
            uri
            :want-stream t  :preserve-uri t )))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (let ((obj (first (yason:parse stream))))
      (close stream)
       obj)))

(defun parse (str)
  (let ((obj (talk-to-gf-server 
               (+s "parse&input="
                   (cl-ppcre:regex-replace-all "\\s" str "%20")))))
    (let ((*package* (find-package "ENG-DCEC"))) 
      (mapcar (lambda (x)
                (read-from-string
                 (concatenate 'string "(" x ")"))) 
              (gethash "trees" obj)))))

(defun random-gf ()
  (let ((obj (talk-to-gf-server "random")))
    (list (gethash "tree" obj)
          (gethash "texts" (first (gethash "linearizations" obj))))))

(defun complete (str)
  (let ((obj (talk-to-gf-server (+s "complete&input="
                                    (cl-ppcre:regex-replace-all "\\s" str "%20")) )))
    (gethash "completions" obj)))

(defun linearize (str)
  (let ((obj (talk-to-gf-server (+s
                                 "linearize&tree="
                                 (drakma:url-encode
                                  str :LATIN-1)) )))
    (gethash "text" obj)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; REPL Interface for interactive parsing ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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




