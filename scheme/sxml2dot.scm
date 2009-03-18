;; sxml2dot -- convert from SXML to graphviz input
;; Copyright Eric Nichols <eric-n@is.naist.jp>
;; Nara Institute of Science and Technology, 2008

(use srfi-13 ssax sxml-tools sxml-transforms)

(define (mrs-sxml->mrs-dot tree)
  (pre-post-order
   tree
   `((*TOP* *macro* . ,(lambda top
                         (car ((sxpath '(*)) top))))
;;      (mrs . ,(lambda elem
;;                `(mrs ("LTOP" ,(get-var
;;                                (get-ltop elem)))
;;                      ("INDEX" ((,(calc-index-sort elem)
;;                                 ,@(get-index-vid elem)
;;                                 )))
;;                      ,@(cdddr elem))))
     (label . ,(lambda elem
		 `("LBL" ,(string-join (cons "h" ((sxpath "@vid/text()") elem))  ""))))
     (var . ,(lambda elem
		 `(,(string-join (cons (let ((s ((sxpath "@sort/text()") elem)))
					 s)
				       ((sxpath "@vid/text()") elem))  
				 ""))))
;;      (var . ,(lambda elem
;;                `((,@((sxpath "@sort/text()") elem)
;;                   ,@((sxpath "@vid/text()") elem))
;;                  ,@(cddr elem))))
;;      (extrapair . ,(lambda elem
;;                      `(,@((sxpath "path/text()") elem)
;;                        ,@((sxpath "value/text()") elem))))
;;      (rargname . ,(lambda elem
;; 		    `(,@((sxpath "text()") elem))))
;;      (constant . ,(lambda elem
;;                     (car ((sxpath "text()") elem))))
;;      (fvpair . ,(lambda elem
;;                   `(,@(cadr elem) ,@(cddr elem))))
;;      (hcons . ,(lambda elem
;;                  `(,@((sxpath "@hreln/text()") elem)
;;                    ,@(cdar ((sxpath "hi") elem))
;;                    ,@(cdar ((sxpath "lo") elem)))))
     (*text* . ,(lambda (tag text) text))
     (*default* . ,(lambda x x)))))

(define (calc-index-sort mrs)
  (let* ((label-arg0
          (alist->hash-table
           (map (lambda (ep)
                  `(,(get-value
                      (get-var
                       (get-label ep)))
                    ,(get-value
                      (get-var
                       (car (get-fvpairs ep))))))
                (get-eps mrs))))
         (arg0 (hash-table-ref/default label-arg0 '("h" "1") #f)))
    (if (and (not (null? arg0))
             (pair? arg0)
             (not (null? (car arg0)))
             (pair? (car arg0)))
        (caar arg0)
        "u")))

(define (get-index-vid mrs)
  (car (get-index mrs)))

(define (get-ltop mrs)
  (cadr mrs))

(define (get-index mrs)
  (caddr mrs))

(define (get-eps mrs)
  (filter (lambda (x)
            (and (list? x)
                 (eq? (car x) 'ep)))
          (cdddr mrs)))

(define (get-qeqs mrs)
  (filter (lambda (x)
            (and (not (null? x))
                 (pair? x)
                 (equal? (car x) "qeq")))
          (cdddr mrs)))

(define (get-pred ep)
  (cadr ep))

(define (get-label ep)
  (caddr ep))

(define (get-fvpairs ep)
  (cdddr ep))

(define (get-rargname fvpair)
  (car fvpair))

(define (get-var fvpair)
  (cadr fvpair))

(define (get-value var)
  (car var))

(define (get-extrapairs var)
  (cdr var))

(define (get-sort value)
  (car value))

(define (get-vid value)
  (cadr value))

(define (get-harg qeq)
  (cadr qeq))

(define (get-larg qeq)
  (caddr qeq))

(define (format-pred pred)
  (format "PRED \"ja:~a\"" (cadr pred)))

(define (format-spred spred)
  (format "PRED \"ja:~s\"" (cadr spred)))

(define (format-rargname rargname)
  (format "~a" rargname))

(define (format-var var)
  (let* ((value (get-value var))
         (value-sort (get-sort value))
         (value-string (format "#~a" (string-join value "")))
         (extrapairs (get-extrapairs var)))
    (cond ((null? extrapairs) value-string)
          ((pair? extrapairs)
           (let ((extrapairs-string
                  (format "~a [ ~a ]"
                          value-sort
                          (string-join (map string-join extrapairs)
                                       ", "))))
             (format "~a & ~a" value-string extrapairs-string))))))

(define (format-index index)
  (format-fvpair index))

(define (format-ltop ltop)
  (format-fvpair ltop))

(define (format-fvpair fvpair)
  (format "~a ~a"
          (format-rargname (get-rargname fvpair))
          (format-var (get-var fvpair))))

(define (format-carg carg)
  (format "~a ~s" (car carg) (cadr carg)))

(define (format-ep ep)
  (format "[ ~a ]"
          (string-join
           (map (lambda (entry)
                  (cond ((eq? (car entry) 'pred)
                         (format-pred entry))
                        ((eq? (car entry) 'spred)
                         (format-spred entry))
                        ((equal? (car entry) "CARG")
                         (format-carg entry))
                        (else (format-fvpair entry))))
                (cdr ep))
           ", ")))

(define (format-eps eps)
  (format "RELS < ~a >"
          (string-join
           (map format-ep eps)
           ",
        ")))

(define (format-qeq qeq)
  (format "qeq & [ HARG ~a, LARG ~a ]"
          (format-var (get-harg qeq))
          (format-var (get-larg qeq))))

(define (format-qeqs qeqs)
  (format "HCONS < ~a >"
          (string-join
           (map format-qeq qeqs)
           ", ")))

(define (mrs-sexp->mrs-string mrs)
  (format "~a"
          (string-join
           `(,(format-ltop (get-ltop mrs))
             ,(format-index (get-index mrs))
             ,(format-eps (get-eps mrs))
             ,(format-qeqs (get-qeqs mrs)))
           ",
  ")))

(define (xml-file->mrs-dot file)
  (mrs-sxml->mrs-dot
   (SSAX:XML->SXML (open-input-file file) '())))

(define (list->set l)
  (letrec ((lh (lambda (a b)
                 (cond ((null? a) (reverse b))
                       ((member (car a) b) (lh (cdr a) b))
                       (else (lh (cdr a)
				 (cons (car a) b)))))))
    (lh l '())))

(define (list->sorted-set l)
  (sort (delete-duplicates l)
	(lambda (x y)
	  (< (string->number (car x))
	     (string->number (car y))))))

(define (get-vars mrs)
  (filter 
   (lambda (x) 
     (and (pair? x)
	  (pair? (cdr x))))
   (list->sorted-set
    (map (lambda (var)
	   `(,@((sxpath "@vid/text()") var)
	     ,@((sxpath "@sort/text()") var)))
	 ((sxpath "//var") mrs)))))

(define (get-labels mrs)
  (list->sorted-set
   (map (lambda (var)
	  `(,@((sxpath "@vid/text()") var) "h"))
	((sxpath "//label") mrs))))

(define (get-labels+vars mrs)
  (list->sorted-set 
   `(,@(get-labels mrs)
     ,@(get-vars mrs))))

(define (get-preds mrs)
  (list->sorted-set
   (map (lambda (x) (cadr x))
	`(,@((sxpath "//pred") mrs)
	  ,@((sxpath "//spred") mrs)))))



(define (main args)
  (let ((xml (car args)))
    (pp (xml-file->mrs-dot xml))
    ))

;; usage: sxml2dot <xml>
(cond-expand
 (compiling (main (command-line-arguments)))
 (else #f))
