;;; MRS-related settings
(setf tsdb::*tsdb-exhaustive-p* nil)
;(setf tsdb::*tsdb-semantix-hook* "mrs::get-mrs-string")
(setf tsdb::*tsdb-write-mrs-p* t)
;;; set and read treebank dir
(tsdb::tsdb :home profile_top)
(tsdb::tsdb :list)
;;; check if profile exists and create if necessary
;(tsdb:tsdb :create "omrs" :skeleton "test")
(if (not (tsdb::verify-tsdb-directory "omrs" :absolute nil))
    (tsdb::do-import-items (format nil "~a/bitext/object" profile_top) 
                           "omrs" :format :bitext))
(setf *tsdb-trees-hook* "lkb::parse-tree-structure")
(tsdb::tsdb :process "omrs" :condition "i-wf=1")
