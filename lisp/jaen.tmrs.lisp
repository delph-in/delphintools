;;; load TSDB cpu definitions
;(tsdb::initialize-tsdb nil :rc (format nil "~a/dot.tsdbrc" root))
;;; read appropriate LKB script and load cpu def
(tsdb:tsdb :cpu :jaen :file t :count 1 :error :exit :wait 600)
(lkb::read-script-file-aux (format nil "~a/uio/jaen/lkb/script" root))
