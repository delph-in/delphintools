(tsdb::tsdb :home profile_top)
(tsdb::tsdb :list)
(loop for n from 0 below limit do
  (let ((dir (format nil "tmrs/~a" n)))
    (if (not (tsdb::verify-tsdb-directory dir :absolute nil))
        (tsdb::do-import-items (format nil "~a/bitext/~a" profile_top fmt) 
          dir :format :bitext))
    (tsdb::tsdb-do-process dir :condition (format nil "result-id=~a" n)
	  :type :transfer :overwrite t :gold "smrs")))
