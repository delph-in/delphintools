(lkb::index-for-generator)
(tsdb::tsdb :home profile_top)
(tsdb::tsdb :list)
(loop for n from 0 below parse-limit do
  (loop for m from 0 below transfer-limit do
    (let ((dir (format nil "gpmrs/~a/~a" n m)))
      (if (not (tsdb::verify-tsdb-directory dir :absolute nil))
          (if (equal fmt "ascii")
              (tsdb::do-import-items (format nil "~a/bitext/ascii" profile_top) 
                dir :format :ascii)
              (tsdb::do-import-items (format nil "~a/bitext/original" profile_top) 
                dir :format :bitext)) )
      (tsdb::tsdb-do-process dir :condition (format nil "(result-id=~a) && (i-id>~a)" m gen-start)
  	    :type :generate :overwrite t :gold (format nil "pmrs/~a" n)) )))
