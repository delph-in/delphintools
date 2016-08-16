(lkb::read-script-file-aux (format nil "~a/dfki/jacy/lkb/script" root))
(tsdb:tsdb :cpu :jacy@pet :file t :count count :error :exit :wait 600)

