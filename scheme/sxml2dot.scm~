;; sxml2dot -- convert from SXML to graphviz input
;; Copyright Eric Nichols <eric-n@is.naist.jp>
;; Nara Institute of Science and Technology, 2008

(use ssax sxml-tools sxml-transforms)

(define (mrs-sxml->mrs-sexp tree)
  (pre-post-order
   tree
   `((*TOP* *macro* . ,(lambda top
			 (car ((sxpath '(*)) top))))
     (mrs . ,(lambda elem
	       `(mrs ("LTOP" ,@(cdadr elem))
		     ("INDEX" (("u" ,@(caaddr elem))))
		     ,@(cdddr elem))))	  		 
     (label . ,(lambda elem
		 `("LBL" (("h" ,@((sxpath "@vid/text()") elem))))))
     (var . ,(lambda elem
	       `((,@((sxpath "@sort/text()") elem)
		  ,@((sxpath "@vid/text()") elem))
		 ,@(cddr elem))))
     (extrapair . ,(lambda elem
		     `(,@((sxpath "path/text()") elem)
		       ,@((sxpath "value/text()") elem))))
     (rargname . ,(lambda elem
		    `(,@((sxpath "text()") elem))))
     (constant . ,(lambda elem
		    (car ((sxpath "text()") elem))))
     (fvpair . ,(lambda elem
		  `(,@(cadr elem) ,@(cddr elem))))
     (hcons . ,(lambda elem
		 `(,@((sxpath "@hreln/text()") elem)
		   ,@(cdar ((sxpath "hi") elem))
		   ,@(cdar ((sxpath "lo") elem)))))
     (*text* . ,(lambda (tag text) text))
     (*default* . ,(lambda x x)))))

(define (mrs-sexp:get-ltop tree)
  (cadr tree))

(define (mrs-sexp:get-index tree)
  (caddr tree))

(define (mrs-sexp:get-eps tree)
  (filter (lambda (x) 
	    (and (list? x)
		 (eq? (car x) 'ep)))
	  (cdddr tree)))

(define (mrs-sexp:get-qeqs tree)
  (filter (lambda (x) 
	    (and (not (null? x))
		 (pair? x)
		 (equal? (car x) "qeq")))
	  (cdddr tree)))

(define (mrs-sexp:get-pred ep)
  (cadr ep))

(define (mrs-sexp:get-label ep)
  (caddr ep))

(define (mrs-sexp:get-fvpairs ep)
  (cdddr ep))

(define (mrs-sexp:get-rargname fvpair)
  (car fvpair))

(define (mrs-sexp:get-var fvpair)
  (cadr fvpair))

(define (mrs-sexp:get-value var)
  (car var))

(define (mrs-sexp:get-extrapairs var)
  (cdr var))

(define (mrs-sexp:get-harg qeq)
  (cadr qeq))

(define (mrs-sexp:get-larg qeq)
  (caddr qeq))

(define (mrs-sexp:format-pred pred)
  (format "PRED \"ja:~a\"" (cadr pred)))

(define (mrs-sexp:format-spred spred)
  (format "PRED \"ja:~s\"" (cadr spred)))

(define (mrs-sexp:format-rargname rargname)
  (format "~a" rargname))

(define (mrs-sexp:format-var var)
  (let* ((value (mrs-sexp:get-value var))
	 (value-sort (car value))
	 (value-string (format "#~a" (string-join value "")))
	 (extrapairs (mrs-sexp:get-extrapairs var)))
    (cond ((null? extrapairs) value-string)
	  ((pair? extrapairs)
	   (let ((extrapairs-string
		  (format "~a [ ~a ]"
			  value-sort
			  (string-join (map string-join extrapairs)
				       ", "))))
	     (format "~a & ~a" value-string extrapairs-string))))))

(define (mrs-sexp:format-index index)
  (mrs-sexp:format-fvpair index))

(define (mrs-sexp:format-ltop ltop)
  (mrs-sexp:format-fvpair ltop))

(define (mrs-sexp:format-fvpair fvpair)
  (format "~a ~a" 
	  (mrs-sexp:format-rargname (mrs-sexp:get-rargname fvpair))
	  (mrs-sexp:format-var (mrs-sexp:get-var fvpair))))

(define (mrs-sexp:format-carg carg)
  (format "~a ~s" (car carg) (cadr carg)))

(define (mrs-sexp:format-ep ep)
  (format "[ ~a ]"
	  (string-join
	   (map (lambda (entry)
		  (cond ((eq? (car entry) 'pred)
			 (mrs-sexp:format-pred entry))
			((eq? (car entry) 'spred)
			 (mrs-sexp:format-spred entry))			
			((equal? (car entry) "CARG")
			 (mrs-sexp:format-carg entry))
			(else (mrs-sexp:format-fvpair entry))))
		(cdr ep))
	   ", ")))

(define (mrs-sexp:format-eps eps)
  (format "RELS < ~a >"
	  (string-join 
	   (map mrs-sexp:format-ep eps)
	   ",
        ")))

(define (mrs-sexp:format-qeq qeq)
  (format "qeq & [ HARG ~a, LARG ~a ]"
	  (mrs-sexp:format-var (mrs-sexp:get-harg qeq))
	  (mrs-sexp:format-var (mrs-sexp:get-larg qeq))))

(define (mrs-sexp:format-qeqs qeqs)
  (format "HCONS < ~a >"
	  (string-join 
	   (map mrs-sexp:format-qeq qeqs)
	   ", ")))

(define (mrs-sexp->mrs-string mrs)
  (format "~a"
	  (string-join 	  
	   `(,(mrs-sexp:format-ltop (mrs-sexp:get-ltop mrs))
	     ,(mrs-sexp:format-index (mrs-sexp:get-index mrs))
	     ,(mrs-sexp:format-eps (mrs-sexp:get-eps mrs))
	     ,(mrs-sexp:format-qeqs (mrs-sexp:get-qeqs mrs)))
	   ",
  ")))

(define (xml-file->mrs-string file)
  (mrs-sexp->mrs-string
   (mrs-sxml->mrs-sexp
    (SSAX:XML->SXML (open-input-file file) '()))))

(define source-file (cadr (argv)))
(define source-mrs-string
  (xml-file->mrs-string source-file))
(pp source-mrs-string)

;(define target-file (caddr (argv)))
;(define target-mrs-string
;  (xml-file->mrs-string source-file))
;(pp target-mrs-string)
