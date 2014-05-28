(ql:quickload :drakma)
(ql:quickload "yason")
(ql:quickload "cl-ppcre")
(defparameter *gf-server-url* "http://localhost:41296/DCEC.pgf?command=")

(defun parse (str)
  (let ((stream (drakma:http-request 
                 (concatenate 'string *gf-server-url*
                              "parse&input="
                              (cl-ppcre:regex-replace-all "\\s" str "%20"))
                 :want-stream t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (let ((obj (first (yason:parse stream))))
      (mapcar (lambda (x)
                (read-from-string
                 (concatenate 'string "(" x ")"))) 
              (gethash "trees" obj)))))


(defun complete (str)
  (let ((stream (drakma:http-request 
                 (concatenate 'string *gf-server-url*
                              "complete&input="
                              (cl-ppcre:regex-replace-all "\\s" str "%20"))
                 :want-stream t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (let ((obj (first (yason:parse stream))))
      (gethash "completions" obj))))




(defun linearize (str)
  (let* ((url  (concatenate 'string
                            *gf-server-url*
                            "linearize&tree="
                            (drakma:url-encode
                             str :LATIN-1)))
         (stream (drakma:http-request 
                  url :method :get
                  :want-stream t :preserve-uri t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (let ((obj (first (yason:parse stream))))
      (gethash "text" obj))))


