(lkb::read-script-file-aux (format nil "~a/lingo/erg/lkb/script" root))
(tsdb:tsdb :cpu :erg :file t :count count :error :exit :wait 600)
