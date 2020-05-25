(use-modules (ice-9 rdelim))

(define (input)
  (let ((lst (map string->number (string-split (read-line) #\-))))
    (cons (car lst) (cadr lst))))

(define (subsequences lst)
  (cond
   ((null? lst) '())
   ((null? (cdr lst)) '(1))
   (#t
    (let ((ss (subsequences (cdr lst))))
      (if (eqv? (car lst) (cadr lst))
          (cons (1+ (car ss)) (cdr ss))
          (cons 1 ss))))))

(define (decreasing lst)
  (cond
   ((null? lst) #f)
   ((null? (cdr lst)) #f)
   (#t (if (char<? (cadr lst) (car lst))
           #t
           (decreasing (cdr lst))))))

(define (range lower upper)
  (iota (- upper lower) lower))

(define (find-valid lower upper)
  (let ((candidates (range lower (1+ upper))))
    (filter
     (lambda (p)
       (let ((lst (string->list (number->string p))))
         (and (not (decreasing lst)) (list? (memv 2 (subsequences lst))))))
     candidates)))

(let* ((range (input))
       (lower (car range))
       (upper (cdr range))
       (x (length (find-valid lower upper))))
  (display x)
  (newline))
