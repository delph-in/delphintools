(setf root (namestring (parse-namestring (getenv "LOGONROOT"))))
(setf (system:getenv "DISPLAY") nil)
(setf (system:getenv "LUI") nil)
(pushnew :lkb *features*)
(pushnew :mrs *features*)
(pushnew :tsdb *features*)
(pushnew :mt *features*)
(pushnew :logon *features*)
