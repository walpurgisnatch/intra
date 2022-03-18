(in-package :cl-user)
(defpackage intra.users
  (:use :cl
        :intra.models
        :intra.utils
        :sxql
        :cl-annot.class
        :datafly)
  (:export :get-user
           :get-user-list
           :find-users
           :find-user
           :create-user
           :login-user
           :update-user
           :delete-user))

(in-package :intra.users)


(defun login-user (name pass)
  (let ((user (retrieve-one
               (select :*
                 (from :users)
                 (where (:= :name name))))))
    (handler-case 
        (when (cl-pass:check-password pass (getf user :pass))
          (list (cons "id" (getf user :id))
                (cons "name" (getf user :name))))
      (error nil))))

(defun get-user (id)
  (retrieve-one
   (select :*
     (from :users)
     (where (:= :id id)))
   :as 'users))

(defun get-user-list (id)
  (retrieve-one
   (select :*
     (from :users)
     (where (:= :id id)))))

(defun find-user (name)
  (retrieve-one
   (select :*
     (from :users)
     (where (:= :name name)))
   :as 'users))

(defun find-users (&optional (name ""))
  (retrieve-all
   (select :*
     (from :users)
     (where (:like :name (concatenate 'string "%" name "%"))))
   :as 'users))

(defun create-user (name pass))
  (handler-case 
      (retrieve-one
       (insert-into :users
         (set= :name name
               :pass (cl-pass:hash pass)
               :created_at (local-time:now)
               :updated_at (local-time:now))
         (returning :id)))
    (error (e) e)))

(defun update-user (id name mail pass status)
  (execute
   (update :users
     (set= :name name
           :pass pass
           :updated_at (local-time:now))
     (where (:= :id id)))))

(defun delete-user (id)
  (execute
   (delete-from :users
     (where (:= :id id)))))
