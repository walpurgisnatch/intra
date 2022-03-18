(in-package :cl-user)
(defpackage intra.web
  (:use :cl
        :caveman2
        :intra.config
        :intra.view
        :intra.db
        :datafly
        :sxql)
  (:export :*web*))
(in-package :intra.web)

;; for @route annotation
(syntax:use-syntax :annot)

;;
;; Application

(defclass <web> (<app>) ())
(defvar *web* (make-instance '<web>))
(defmethod lack.component:call :around ((app <web>) env)
  (let ((datafly:*connection*
          (apply #'datafly:connect-cached (cdr (assoc :maindb (config :databases))))))
    (prog1
        (call-next-method))))
(clear-routing-rules *web*)

;;
;; Routing rules

(defroute "/api/*" ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (next-route))

(defroute ("/api/*" :method :POST) ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (next-route))

(defroute ("/api/*" :method :DELETE) ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (next-route))

(defroute ("/api/*" :method :PUT) ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (next-route))

(defroute ("/*" :method :OPTIONS) ()
  (setf (getf (response-headers *response*) :Access-Control-Allow-Origin) "*")
  (setf (getf (response-headers *response*) :Access-Control-Allow-Headers) "*")
  (setf (getf (response-headers *response*) :Access-Control-Allow-Methods) "*")  
  (next-route))

(defroute "/" ()
  (render #P"index.html"))

(defroute "/api/file" (&key file)
  ())

;;
;; Error pages

(defmethod on-exception ((app <web>) (code (eql 404)))
  (declare (ignore app))
  (merge-pathnames #P"_errors/404.html"
                   *template-directory*))
