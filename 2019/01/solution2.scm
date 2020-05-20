(use-modules (ice-9 rdelim))

(define (input)
  (let ((line (read-line)))
    (if (eof-object? line)
        '()
        (cons (string->number line) (input)))))

(define (fuel m)
  (- (truncate (/ m  3)) 2))

(define (fuel-list m)
  (let ((f (fuel m)))
    (if (< f 0)
        '()
        (cons f (fuel-list f)))))

(define (fuelfuel m)
  (apply + (fuel-list m)))

(define (total-fuel modules)
  (apply
   +
   (map fuelfuel modules)))

(display (total-fuel (input)))
(newline)
