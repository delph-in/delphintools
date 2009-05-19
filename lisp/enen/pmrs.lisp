(tsdb:tsdb :cpu :enen :file t :count count :error :exit :wait 600)
(lkb::read-script-file-aux (format nil "~a/uio/enen/lkb/script" root))
