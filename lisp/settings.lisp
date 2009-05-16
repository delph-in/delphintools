;;; settings for parse iterations, edges, etc.
(setf limit 3)
(setf tsdb::*tsdb-maximal-number-of-analyses* limit)
(setf tsdb::*tsdb-maximal-number-of-results* limit)
(set (intern "*MAXIMUM-NUMBER-OF-EDGES*" :lkb) 100000)
(set (intern "*UNPACK-EDGE-ALLOWANCE*" :lkb) 100000)
(set (intern "*TSDB-MAXIMAL-NUMBER-OF-EDGES*" :tsdb) 100000)
(setf mt::*transfer-edge-limit* 10000)
