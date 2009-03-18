;;; xml2sxml -- convert XML into s-expression representation
;;; Copyright 2008/05/13, Eric Nichols <eric-n@is.naist.jp>, Nara Institute of Science and Technology

(require-extension ssax)
(pp (SSAX:XML->SXML (current-input-port) '()))
