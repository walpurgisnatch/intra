(in-package :cl-user)
(defpackage intra.schema
  (:use :cl))

(in-package :intra.schema)

(mito:connect-toplevel :postgres :database-name "walpurgisblog" :username "walpurgisblog" :password "walpurgisblog")

(defun ensure-tables ()
  (mapcar #'ensure-table-exists '(users projects tasks comments)))

(defun migrate-tables ()
  (mapcar #'migrate-table '(users projects tasks comments)))

(deftable users ()
  ((name          :col-type (:varchar 64))
   (pass          :col-type (:varchar 128))))

(deftable projects ()
  ((name          :col-type (:varchar 128))))

(deftable tasks ()
  ((title         :col-type (:varchar 64))
   (description   :col-type :text)
   (project       :references projects)
   (status        :col-type (:varchar 64))
   (user          :col-type (or :integer :null))
   (rating        :col-type :integer)))

(deftable comments ()
  ((body          :col-type :text)
   (user          :references users)
   (task          :references tasks)))


(ensure-tables)
(migrate-tables)
