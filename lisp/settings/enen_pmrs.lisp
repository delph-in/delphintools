(setf fmt "ascii")
(setf limit 1) ;;; consider 10 transfer results
(setf count 1)
(setf tsdb::*tsdb-maximal-number-of-analyses* 100)
(setf tsdb::*tsdb-maximal-number-of-results* 10)
(set (intern "*MAXIMUM-NUMBER-OF-EDGES*" :lkb) 100000)
(set (intern "*UNPACK-EDGE-ALLOWANCE*" :lkb) 100000)
(set (intern "*TSDB-MAXIMAL-NUMBER-OF-EDGES*" :tsdb) 100000)
