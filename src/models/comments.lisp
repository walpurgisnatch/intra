(in-package :cl-user)
(defpackage intra.projects
  (:use :cl
        :intra.models
        :sxql
        :datafly)
  (:export :get-comments
           :get-comment
           :create-comment
           :update-comment
           :rate-comment
           :delete-comment))

(in-package :intra.comments)


(defun get-comment (id)
  (retrieve-one
   (select :*
     (from :comments)
     (where (:= :id id)))
   :as 'comments))

(defun get-comments (task)
  (retrieve-all
   (select :*
     (from :comments)
     (where (:= :task task))
     (order-by (:desc :created_at)))
   :as 'comments))

(defun create-comment (task user body)
  (handler-case 
      (execute
       (insert-into :comments
         (set= :user user
               :body body
               :task task
               :created_at (local-time:now)
               :updated_at (local-time:now))))
    (error (e) e)))

(defun update-comment (id body)
  (execute
   (update :comments
     (set= :body       body
           :updated_at (local-time:now))
     (where (:= :id id)))))

(defun delete-comment (id)
  (execute
   (delete-from :comments
     (where (:= :id id)))))
