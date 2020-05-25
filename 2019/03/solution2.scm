(use-modules (ice-9 rdelim) (ice-9 regex))

(define (dir d)
  (case d
    ((#\R) '(1 . 0))
    ((#\L) '(-1 . 0))
    ((#\U) '(0 . 1))
    ((#\D) '(0 . -1))
    ))

(define (input)
  (let* ((p (make-regexp "([RLUD])([0-9]+)"))
         (matches
          (map
           (lambda (x) (regexp-exec p x))
           (string-split (read-line) #\,))))
    (map (lambda (m) (cons
                      (string-ref (match:substring m 1) 0)
                      (string->number (match:substring m 2))))
         matches)
    ))

(define (run-wire p z grid wire first distances)
  (letrec ((step (lambda (p d)
                   (cons (+ (car p) (car d)) (+ (cdr p) (cdr d)))))
           (stretch (lambda (p d l z)
                      (if (> l 0)
                          (let ((p' (step p d)) (z' (1+ z)))
                            (if first
                                (hash-set! grid p' z')
                                (let ((first-dist (hash-get-handle grid p')))
                                  (if (pair? first-dist)
                                      (set! distances
                                        (cons (+ (cdr first-dist) z')
                                              distances)))))
                            (stretch p' d (1- l) z'))
                          (cons p z))
                      )))

    ;; I don't know if adding to distances as a side effect of stretch
    ;; is good Scheme. But it works.
    (if (not (null? wire))
        (let* ((d (dir (caar wire)))
               (l (cdar wire))
               (x (stretch p d l z))
               (p' (car x))
               (z' (cdr x)))
          (run-wire p' z' grid (cdr wire) first distances))
        distances)))

(let ((wire0 (input)) (wire1 (input)) (grid (make-hash-table)))
  (run-wire '(0 . 0) 0 grid wire0 #t '())
  (let* ((distances (run-wire '(0 . 0) 0 grid wire1 #f '()))
         (min-distance (apply min distances)))
    (format #t "~a~%" min-distance)))
