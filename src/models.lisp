(in-package :cl-user)
(defpackage intra.models
  (:use :cl :sxql :cl-annot.class :datafly)
  (:export :users-tasks
           :tasks-user
           :tasks-coms
           :comments-owner
           :comments-place))

(in-package :intra.models)

(syntax:use-syntax :annot)

@export-accessors
@export
(defmodel (users (:inflate created-at #'datetime-to-timestamp)
                 (:inflate updated-at #'datetime-to-timestamp)
                 (:has-many (tasks tasks)
                            (select :*
                              (from :tasks)
                              (where (:= :user id))
                              (order-by (:desc :created_at)))))
  id
  name
  pass
  created-at
  updated-at)

@export-accessors
@export
(defmodel (projects (:inflate created-at #'datetime-to-timestamp)
                    (:inflate updated-at #'datetime-to-timestamp))
  id
  name
  created-at
  updated-at)

@export-accessors
@export
(defmodel (tasks (:inflate created-at #'datetime-to-timestamp)
                    (:inflate updated-at #'datetime-to-timestamp)
                    (:has-a (user users) (where (:= :id user)))
                    (:has-many (coms comments)
                               (select :*
                                 (from :comments)
                                 (where (:= :task id))
                                 (order-by (:desc :created_at)))))
  id
  type
  title
  description
  project
  status
  user
  rating
  comments
  created-at
  updated-at)

@export-accessors
@export
(defmodel (comments (:inflate created-at #'datetime-to-timestamp)
                    (:inflate updated-at #'datetime-to-timestamp)
                    (:has-a (owner users) (where (:= :id user)))
                    (:has-a (place tasks) (where (:= :id task))))

  id
  user
  body
  task
  created-at
  updated-at)
