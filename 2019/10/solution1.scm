(use-modules (ice-9 rdelim))

(define (problem-input)
  (let ((l (read-line)))
    (if (eof-object? l)
        '()
        (cons
         (map (lambda (c)
                (eq? #\# c))
              (string->list l))
         (problem-input)))))

(define (enumerate-asteroids asteroids f)
  (let ((asteroid-map (make-hash-table)))
    (for-each
     (lambda (y row)
       (for-each
        (lambda (x a)
          (f x y a)
          (hash-set! asteroid-map (cons x y) a))
        (iota (length row)) row))
     (iota (length asteroids)) asteroids)
    asteroid-map))

(define (enumerate xs ys)
  (let ((inner (lambda (x ys) (map cons (make-list (length ys) x) ys))))
    (apply append (map (lambda (x) (inner x ys)) xs))))

(define (v/ v d)
  (let ((x (car v)) (y (cdr v)))
    (cons (/ x d) (/ y d))))

(define (make-unique vs)
  (let ((vector-set (make-hash-table)))
    (for-each
     (lambda (v)
       (let* ((x (car v)) (y (cdr v)) (d (gcd x y)))
         (hash-set! vector-set (v/ v d) #t)))
     vs)
    (hash-map->list (lambda (k v) k) vector-set)))

(define (copy t)
  (let* ((c (make-hash-table))
         (set (lambda (k v) (hash-set! c k v))))
    (hash-for-each set t)
    c))

(define (inside w h c)
  (let ((x' (car c))
        (y' (cdr c)))
    (and (>= x' 0) (>= y' 0) (< y' w) (< x' h))))

(define (vector-add a b)
  (let ((ax (car a)) (ay (cdr a)) (bx (car b)) (by (cdr b)))
    (cons (+ ax bx) (+ ay by))))

(define (count-visible w h x y asteroid-map)
  (letrec ((asteroid-map' (copy asteroid-map))
           (rays (make-unique
                  (delete
                   '(0 . 0)
                   (enumerate (iota w (- x)) (iota h (- y))))))
           (search
            (lambda (p ray)
              (let ((p' (vector-add p ray)))
                (if (inside w h p')
                    (if (hash-ref asteroid-map' p')
                        1
                        (search p' ray))
                    0))))
           (search-all
            (lambda (rays)
              (if (null? rays)
                  0
                  (+ (search (cons x y) (car rays))
                     (search-all (cdr rays)))))))
    (search-all rays)))

(letrec*
    ((input (problem-input))
     (width (length (car input)))
     (height (length input))
     (asteroid-map (make-hash-table))
     (asteroids '())
     (best-location
      (lambda (asteroids)
        (if (null? asteroids)
            0
            (let ((x (caar asteroids))
                  (y (cdar asteroids)))
              (max (count-visible width height x y asteroid-map)
                   (best-location (cdr asteroids))))))))

  (enumerate-asteroids
   input
   (lambda (x y a)
     (if a (hash-set! asteroid-map (cons x y) #t))))

  (enumerate-asteroids
   input
   (lambda (x y a)
     (if a (set! asteroids (cons (cons x y) asteroids)))))

  (format #t "~a~%" (best-location asteroids)))
