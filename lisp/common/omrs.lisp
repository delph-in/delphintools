(setf tsdb::*tsdb-exhaustive-p* nil)
;(setf tsdb::*tsdb-semantix-hook* "mrs::get-mrs-string")
(setf tsdb::*tsdb-write-mrs-p* t)
(tsdb::tsdb :home profile_top)
(tsdb::tsdb :list)
(let ((dir "omrs"))
  (if (not (tsdb::verify-tsdb-directory dir :absolute nil))
      (if (equal fmt "ascii")
          (tsdb::do-import-items (format nil "~a/bitext/ascii" profile_top) 
            dir :format :ascii)
          (tsdb::do-import-items (format nil "~a/bitext/original" profile_top) 
            dir :format :bitext))) )
(setf *tsdb-trees-hook* "lkb::parse-tree-structure")
(tsdb::tsdb :process "omrs" :condition "i-wf=1")
