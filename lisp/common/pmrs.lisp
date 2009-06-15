;; Starting common/pmrs.lisp
(setf tsdb::*tsdb-transfer-include-fragments-p* t)
(tsdb::tsdb :home profile_top)
(tsdb::tsdb :list)
(loop for n from 0 below limit do
  (let ((dir (format nil "pmrs/~a" n)))
    (if (not (tsdb::verify-tsdb-directory dir :absolute nil))
        (if (equal fmt "ascii")
            (tsdb::do-import-items (format nil "~a/bitext/ascii" profile_top) 
              dir :format :ascii)
            (tsdb::do-import-items (format nil "~a/bitext/original" profile_top) 
              dir :format :bitext)) )
    (tsdb::tsdb-do-process dir :condition (format nil "(result-id=~a) && (i-id>~a)" n transfer-start)
	  :type :transfer :overwrite t :gold "smrs")))
;; Ending common/pmrs.lisp
