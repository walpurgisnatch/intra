(in-package :cl-user)
(defpackage intra.tasks
  (:use :cl
        :intra.models
        :sxql
        :datafly
        :intra.utils)
  (:export  :get-tasks
            :get-task
            :create-task
            :update-task
            :delete-task))

(in-package :intra.tasks)


(defun get-task (id)
  (let ((task (car (find-where tasks (:= :id id)))))
    (setf (tasks-comments task) (tasks-coms task))
    task))

(defun get-tasks (&optional (title ""))
  (find-where tasks (:like :title (wildcard title))))

(defun create-task (title description project user &optional (status "new") (rating 3)) 
  (handler-case 
      (retrieve-one
       (insert-into :tasks
         (set= :title title
               :description description
               :project project
               :user user
               :status status
               :rating rating
               :created_at (local-time:now)
               :updated_at (local-time:now))
         (returning :id)))
    (error (e) e)))

(defun update-task (title description project user status rating)
  (execute 
   (update :tasks
     (set= :title title
           :description description
           :project project
           :user user
           :status status
           :rating rating
           :updated_at (local-time:now))
           (where (:= :id id)))))

(defun delete-task (id)
  (execute 
   (delete-from :tasks
     (where (:= :id id)))))
