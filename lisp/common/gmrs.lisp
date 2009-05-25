(lkb::index-for-generator)
(tsdb::tsdb :home profile_top)
(tsdb::tsdb :list)
(loop for n from 0 below limit do
  (loop for m from 0 below limit do
    (let ((dir (format nil "gmrs/~a/~a" n m)))
      (if (not (tsdb::verify-tsdb-directory dir :absolute nil))
          (tsdb::do-import-items (format nil "~a/bitext/~a" profile_top fmt) 
            dir :format :bitext))
      (tsdb::tsdb-do-process dir :condition (format nil "result-id=~a" m)
  	    :type :generate :overwrite t :gold (format nil "tmrs/~a" n)) )))
