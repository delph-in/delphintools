;;; settings for parse iterations, edges, etc.
(setf limit 3)
(set (intern "*tsdb-maximal-number-of-analyses*" :tsdb) limit)
(set (intern "*tsdb-maximal-number-of-results*" :tsdb) limit)
(set (intern "*MAXIMUM-NUMBER-OF-EDGES*" :lkb) 10000)
(set (intern "*UNPACK-EDGE-ALLOWANCE*" :lkb) 10000)
(set (intern "*TSDB-MAXIMAL-NUMBER-OF-EDGES*" :tsdb) 10000)
(set (intern "*transfer-edge-limit*" :mt) 10000)
