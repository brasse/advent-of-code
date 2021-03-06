(use-modules (ice-9 rdelim))

(define (problem-input)
  (map string->number (string-split (read-line) #\,)))

(define (digit i n)
  (modulo (quotient i (expt 10 n)) 10))

(define (opcode i)
  (modulo i 100))

(define (make-memory-map program)
  (let ((memory (make-hash-table)))
    (for-each
     (lambda (i j)
       (hash-set! memory i j))
     (iota (length program)) program)
    memory))

(define (make-computer program input)
  (let ((memory (make-memory-map program))
        (p 0)
        (rel-base 0)
        (output '()))
    (lambda ()
      (let*
          ((rmem (lambda (addr)
                   (hash-ref memory addr 0)))
           (wmem (lambda (addr x) (hash-set! memory addr x)))
           (imm (lambda (n)
                  (+ p n)))
           (pos (lambda (n)
                  (rmem (+ p n))))
           (rel (lambda (n)
                  (+ rel-base (rmem (+ p n)))))
           (mode (lambda (i n)
                   (case (digit i n)
                     ((0) pos)
                     ((1) imm)
                     ((2) rel))))
           (w (lambda (i n value)
                (wmem ((mode i (1+ n)) n) value)))
           (r (lambda (i n)
                (rmem ((mode i (1+ n)) n)))))
        (set! output '())
        (while #t
          (let ((i (rmem p)))
            (case (opcode i)
              ((1)
               (w i 3 (+ (r i 1) (r i 2)))
               (set! p (+ p 4)))
              ((2)
               (w i 3 (* (r i 1) (r i 2)))
               (set! p (+ p 4)))
              ((3)
               (w i 1 (input))
               (set! p (+ p 2)))
              ((4)
               (set! output (r i 1))
               (set! p (+ p 2))
               (break))
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
                   (w i 3 1)
                   (w i 3 0))
               (set! p (+ p 4)))
              ((8)
               (if (= (r i 1) (r i 2))
                   (w i 3 1)
                   (w i 3 0))
               (set! p (+ p 4)))
              ((9)
               (set! rel-base (+ rel-base (r i 1)))
               (set! p (+ p 2)))
              ((99) (break)))
            ))
        output))))

(define (print-screen screen)
  (let* ((bounds
          (hash-fold
           (lambda (p v r)
             (if (> v 0)
                 (let ((minx (car r)) (maxx (cadr r))
                       (miny (caddr r)) (maxy (cadddr r))
                       (x (car p)) (y (cdr p)))
                   (list (if (< x minx) x minx)
                         (if (> x maxx) x maxx)
                         (if (< y miny) y miny)
                         (if (> y maxy) y maxy)))
                 r))
           (list +inf.0 -inf.0 +inf.0 -inf.0)
           screen))
         (minx (car bounds)) (maxx (cadr bounds))
         (miny (caddr bounds)) (maxy (cadddr bounds)))
    (for-each
     (lambda (y)
       (for-each
        (lambda (x)
          (let* ((tile-id (hash-ref screen (cons x y) 0))
                 (c (case tile-id
                      ((0) #\space)
                      ((1) #\|)
                      ((2) #\#)
                      ((3) #\-)
                      ((4) #\*))))
            (display c)))
        (iota (1+ (- maxx minx)) minx))
       (newline))
     (iota (1+ (- maxy miny)) miny))))

(let* ((screen (make-hash-table))
       (ball-x #f)
       (paddle-x #f)
       (score 0)
       (joystick
        (lambda ()
          (if (or (eq? ball-x #f) (eq? paddle-x #f))
              0
              (cond
               ((< ball-x paddle-x) -1)
               ((> ball-x paddle-x) 1)
               (else 0)))))
       (program (problem-input))
       (foobogus (list-set! program 0 2))
       (computer (make-computer program joystick)))

  ;; Run program
  (while #t
    (let ((x (computer))
          (y (computer))
          (tile-id (computer)))
      (if (null? x)
          (break))
      (if (and (= x -1) (= y 0))
          (set! score tile-id)
          (begin
            (hash-set! screen (cons x y) tile-id)
            (cond
             ((= tile-id 3) (set! paddle-x x))
             ((= tile-id 4) (set! ball-x x)))))

      ;; (print-screen screen)
      ;; (format #t "score: ~a~%" score)
      ))

  (format #t "~a~%" score))
