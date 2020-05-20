(use-modules (ice-9 rdelim))

(define (input)
  (let ((line (read-line)))
    (if (eof-object? line)
        '()
        (cons (string->number line) (input)))))

(define (total-fuel modules)
  (apply
   +
   (map (lambda (m)
          (- (truncate (/ m  3)) 2))
        modules)))

(display (total-fuel (input)))
(newline)
