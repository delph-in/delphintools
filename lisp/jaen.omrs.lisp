;;; load TSDB cpu definitions
;(tsdb::initialize-tsdb nil :rc (format nil "~a/dot.tsdbrc" root))
;;; read appropriate LKB script and load cpu def
(tsdb:tsdb :cpu :terg :file t :count 1 :error :exit :wait 600)
(lkb::read-script-file-aux (format nil "~a/lingo/terg/lkb/script" root))
