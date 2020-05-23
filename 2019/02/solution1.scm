(use-modules (ice-9 rdelim))

(define (input)
  (list->vector (map string->number (string-split (read-line) #\,))))

(define (ind program pos)
  (vector-ref program (vector-ref program pos)))

(define (imm program pos)
  (vector-ref program pos))

(define (w program pos value)
  (vector-set! program pos value))

(define (run program)
  (let ((p 0))
    (while #t
      (case (vector-ref program p)
        ((1)
         (w program
            (imm program (+ p 3))
            (+ (ind program (+ p 1)) (ind program (+ p 2)))))
        ((2)
         (w program
            (imm program (+ p 3))
            (* (ind program (+ p 1)) (ind program (+ p 2)))))
        ((99) (break))
        )
      (set! p (+ p 4)))))

(define p (input))
(vector-set! p 1 12)
(vector-set! p 2 2)
(run p)

(display (vector-ref p 0))
(newline)
