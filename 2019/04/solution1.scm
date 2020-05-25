(use-modules (ice-9 rdelim))

(define (input)
  (let ((lst (map string->number (string-split (read-line) #\-))))
    (cons (car lst) (cadr lst))))

(define (has-double p)
  (letrec
      ((test (lambda (lst)
               (cond
                ((null? lst) #f)
                ((null? (cdr lst)) #f)
                (#t (if (eq? (car lst) (cadr lst))
                        #t
                        (test (cdr lst))))))))
    (test (string->list (number->string p)))))

(define (decreasing p)
  (letrec
      ((test (lambda (lst)
               (cond
                ((null? lst) #f)
                ((null? (cdr lst)) #f)
                (#t (if (char<? (cadr lst) (car lst))
                        #t
                        (test (cdr lst))))))))
    (test (string->list (number->string p)))))

(define (range lower upper)
  (iota (- upper lower) lower))

(define (find-valid lower upper)
  (let ((candidates (range lower (1+ upper))))
    (filter
     (lambda (p) (and (not (decreasing p))  (has-double p)))
     candidates)))

(let* ((range (input))
       (lower (car range))
       (upper (cdr range))
       (x (length (find-valid lower upper))))
  (display x)
  (newline))
