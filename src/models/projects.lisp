(in-package :cl-user)
(defpackage intra.projects
  (:use :cl
        :intra.models
        :sxql
        :datafly)
  (:export :get-project
           :create-project
           :update-project
           :rate-project
           :delete-project))

(in-package :intra.projects)


(defun get-project (id)
  (retrieve-one
   (select :*
     (from :projects)
     (where (:= :id id)))
   :as 'projects))

(defun create-project (name)
  (handler-case 
      (execute
       (insert-into :projects
         (set= :name name
               :created_at (local-time:now)
               :updated_at (local-time:now))))
    (error (e) e)))

(defun update-project (id name)
  (execute
   (update :projects
     (set= :name name
           :updated_at (local-time:now))
     (where (:= :id id)))))

(defun delete-project (id)
  (execute
   (delete-from :projects
     (where (:= :id id)))))
