(tsdb:tsdb :cpu :jacy :file t :count 1 :error :exit :wait 600)
(lkb::read-script-file-aux (format nil "~a/dfki/jacy/lkb/script" root))