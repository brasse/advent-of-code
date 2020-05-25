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

(define (manhattan p)
  (+ (abs (car p)) (abs (cdr p))))

(define (run-wire p grid wire first distances)
  (letrec ((step (lambda (p d)
                   (cons (+ (car p) (car d)) (+ (cdr p) (cdr d)))))
           (stretch (lambda (p d l)
                      (if (> l 0)
                          (let ((p' (step p d)))
                            (if first
                                (hash-set! grid p' first)
                                (if (pair? (hash-get-handle grid p'))
                                    (set! distances
                                      (cons (manhattan p') distances))))
                            (stretch p' d (1- l)))
                          p)
                      )))

    ;; I don't know if adding to distances as a side effect of stretch
    ;; is good Scheme. But it works.
    (if (not (null? wire))
        (let ((d (dir (car (car wire))))
              (l (cdr (car wire))))
          (run-wire (stretch p d l) grid (cdr wire) first distances))
        distances)))

(let ((wire0 (input)) (wire1 (input)) (grid (make-hash-table)))
  (run-wire '(0 . 0) grid wire0 #t '())
  (let* ((distances (run-wire '(0 . 0) grid wire1 #f '()))
         (min-distance (apply min distances)))
    (format #t "~a~%" min-distance)))
