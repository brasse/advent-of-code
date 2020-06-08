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
          ((rmem (lambda (addr) (hash-ref memory addr 0)))
           (wmem (lambda (addr x) (hash-set! memory addr x)))
           (pos (lambda (n)
                  (+ p n)))
           (ind (lambda (n)
                  (rmem (+ p n))))
           (rel (lambda (n)
                  (+ rel-base (rmem (+ p n)))))
           (mode (lambda (i n)
                   (case (digit i n)
                     ((0) ind)
                     ((1) pos)
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

(define (make-robot)
  (let ((pos '(0 . 0))
        (dir '(0 . -1))
        (grid (make-hash-table)))
    (define (get-pos) pos)
    (define (get-color) (hash-ref grid pos 0))
    (define (get-grid) grid)
    (define (paint color) (hash-set! grid pos color))
    (define (turn d)
      (let ((dir'
             (cond
              ;; left
              ((and (= d 0) (equal? dir '(0 . -1))) '(-1 . 0))
              ((and (= d 0) (equal? dir '(-1 . 0))) '(0 . 1))
              ((and (= d 0) (equal? dir '(0 . 1))) '(1 . 0))
              ((and (= d 0) (equal? dir '(1 . 0))) '(0 . -1))
              ;; right
              ((and (= d 1) (equal? dir '(0 . -1))) '(1 . 0))
              ((and (= d 1) (equal? dir '(1 . 0))) '(0 . 1))
              ((and (= d 1) (equal? dir '(0 . 1))) '(-1 . 0))
              ((and (= d 1) (equal? dir '(-1 . 0))) '(0 . -1)))))
        (set! dir dir')))
    (define (step)
      (let ((px (car pos)) (py (cdr pos))
            (dx (car dir)) (dy (cdr dir)))
        (set! pos (cons (+ px dx) (+ py dy)))))

    (lambda args
      (apply
        (case (car args)
          ((get-pos) get-pos)
          ((get-color) get-color)
          ((get-grid) get-grid)
          ((paint) paint)
          ((turn) turn)
          ((step) step)
          (else (error "Invalid method!")))
        (cdr args)))))

(let* ((program (problem-input))
       (robot (make-robot))
       (camera (lambda ()
                 (robot 'get-color)))
       (computer (make-computer program camera))
       (painted (make-hash-table)))
  (while #t
    (let ((color (computer))
          (turn-dir (computer)))
      (if (null? color)
          (break))
      (robot 'paint color)
      (robot 'turn turn-dir)
      (robot 'step)))
  (format #t "~a~%" (hash-count (const #t) (robot 'get-grid))))
