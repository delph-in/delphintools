(tsdb:tsdb :cpu :terg+tnt :file t :count 1 :error :exit :wait 600)
(lkb::read-script-file-aux (format nil "~a/lingo/terg/lkb/script" root))
