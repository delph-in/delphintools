;;; set and read treebank dir
(tsdb::tsdb :home profile_top)
(tsdb::tsdb :list)
;;; check if profile exists and create if necessary
;(tsdb:tsdb :create "smrs" :skeleton "test")
(loop for n from 0 below limit do
  (let ((dir (format nil "tmrs/~a" n)))
    (if (not (tsdb::verify-tsdb-directory dir :absolute nil))
        (tsdb::do-import-items (format nil "~a/bitext/original" profile_top) 
          dir :format :bitext))
    (tsdb::tsdb-do-process dir :condition (format nil "result-id=~a" n)
	  :type :transfer :overwrite t :gold "smrs")))
