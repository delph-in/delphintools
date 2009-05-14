;;; get LOGON root
(setf root (namestring (parse-namestring (getenv "LOGONROOT"))))
(setf (system:getenv "DISPLAY") nil)
;;; load lkb and push on LOGON features
;(load (format nil "~a/lingo/lkb/src/general/loadup.lisp" root))
(pushnew :lkb *features*)
(pushnew :mrs *features*)
(pushnew :tsdb *features*)
(pushnew :mt *features*)
(pushnew :logon *features*)
