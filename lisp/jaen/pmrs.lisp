;(tsdb:tsdb :cpu :jaen :file t :count count :error :exit :wait 600)
(lkb::read-script-file-aux (format nil "~a/uio/jaen/lkb/script" root))
