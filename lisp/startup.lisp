
(setf root (namestring (parse-namestring (getenv "LOGONROOT"))))
(setf (system:getenv "DISPLAY") nil)
(setf (system:getenv "LUI") nil)

(setf parse-start -1)
(setf gen-start -1)
(setf transfer-start -1)

(load (format nil "~a/env/dot.tsdbrc" (getenv "DTHOME")))

(pushnew :lkb *features*)
(pushnew :mrs *features*)
(pushnew :tsdb *features*)
(pushnew :mt *features*)
(pushnew :logon *features*)

