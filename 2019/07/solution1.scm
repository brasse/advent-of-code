(use-modules (ice-9 rdelim))

(define (problem-input)
  (list->vector (map string->number (string-split (read-line) #\,))))

(define (make-program-input lst)
  (lambda ()
    (let ((x (car lst)))
      (set! lst (cdr lst))
      x)))

(define (permute lst)
  (cond
   ((= (length lst) 1) (list lst))
   (else (apply
          append
          (map
           (lambda (i)
             (map
              (lambda (j) (cons i j))
              (permute (delete i lst))))
           lst)))))

(define (digit i n)
  (modulo (quotient i (expt 10 n)) 10))

(define (opcode i)
  (modulo i 100))

(define (run program input)
  (let* ((p 0)
         (output '())
         (imm (lambda (offset)
                (vector-ref program (+ p offset))))
         (ind (lambda (offset)
                (vector-ref program (vector-ref program (+ p offset)))))
         (w (lambda (pos value)
              (vector-set! program pos value)))
         (mode (lambda (i n)
                 (case (digit i n)
                   ((0) ind)
                   ((1) imm))))
         (r (lambda (i n)
              ((mode i (1+ n)) n))))
    (while #t
      (let ((i (imm 0)))
        (case (opcode i)
          ((1)
           (w (imm 3) (+ (r i 1) (r i 2)))
           (set! p (+ p 4)))
          ((2)
           (w (imm 3) (* (r i 1) (r i 2)))
           (set! p (+ p 4)))
          ((3)
           (w (imm 1) (input))
           (set! p (+ p 2)))
          ((4)
           (set! output (cons (r i 1) output))
           (set! p (+ p 2)))
          ((5)
           (if (not (zero? (r i 1)))
               (set! p (r i 2))
               (set! p (+ p 3))))
          ((6)
           (if (zero? (r i 1))
               (set! p (r i 2))
               (set! p (+ p 3))))
          ((7)
           (if (< (r i 1) (r i 2))
               (w (imm 3) 1)
               (w (imm 3) 0))
           (set! p (+ p 4)))
          ((8)
           (if (= (r i 1) (r i 2))
               (w (imm 3) 1)
               (w (imm 3) 0))
           (set! p (+ p 4)))
          ((99) (break)))
        ))
    output))

(define (amplify program input settings)
  (if (null? settings)
      input
      (amplify program
               (car (run (vector-copy program)
                         (make-program-input (list (car settings) input))))
               (cdr settings))))

(define (find program setting-permutations)
    (if (null? setting-permutations)
        -inf.0
        (max (amplify program 0 (car setting-permutations))
             (find program (cdr setting-permutations)))))

(let ((best-settings
       (find (problem-input) (permute (list 0 1 2 3 4)))))
  (format #t "~a~%" best-settings))
