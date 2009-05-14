;;; MRS-related settings
(setf tsdb::*tsdb-exhaustive-p* nil)
;(setf tsdb::*tsdb-semantix-hook* "mrs::get-mrs-string")
(setf tsdb::*tsdb-write-mrs-p* t)
;;; set and read treebank dir
(tsdb::tsdb :home profile_top)
(tsdb::tsdb :list)
;;; check if profile exists and create if necessary
;(tsdb:tsdb :create "smrs" :skeleton "test")
(if (not (tsdb::verify-tsdb-directory "smrs" :absolute nil))
    (tsdb::do-import-items (format nil "~a/bitext/original" profile_top) 
                           "smrs" :format :bitext))
(setf *tsdb-trees-hook* "lkb::parse-tree-structure")
(tsdb::tsdb :process "smrs" :condition "i-wf=1")
