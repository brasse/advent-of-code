(use-modules (ice-9 rdelim))

;; This solution is a bit messy. Not much though. Messy mainly
;; because I got the orientation of my coordinate system(s)
;; screwed up. Hence weird-ray-add.

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

(define (v* v d)
  (let ((x (car v)) (y (cdr v)))
    (cons (* x d) (* y d))))

(define (v-length v)
  (let ((x (car v))
        (y (cdr v)))
    (sqrt (+ (* x x) (* y y)))))

(define (v-norm v)
  (v/ v (v-length v)))

(define pi 3.1415926535897927)
(define (v-rad v)
  (let* ((v' (v-norm v))
         (x' (car v'))
         (y' (cdr v')))
    (cond
     ((and (>= x' 0) (>= y' 0)) (- (/ pi 2) (acos x')))
     ((and (>= x' 0) (< y' 0)) (+ (/ pi 2) (acos x')))
     ((and (< x' 0) (< y' 0)) (+ (/ pi 2) (acos x')))
     ((and (< x' 0) (>= y' 0)) (- (+ (* pi 2) (/ pi 2)) (acos x')))
     )))

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
    (and (>= x' 0) (>= y' 0) (< y' h) (< x' w))))

(define (vector-add a b)
  (let ((ax (car a)) (ay (cdr a)) (bx (car b)) (by (cdr b)))
    (cons (+ ax bx) (+ ay by))))

(define (weird-ray-add a b)
  (let ((ax (car a)) (ay (cdr a)) (bx (car b)) (by (cdr b)))
    (cons (+ ax bx) (- ay by))))

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

(define (rotate-laser w h x y asteroid-map)
  (letrec ((asteroid-map' (copy asteroid-map))
           (vaporized (list))
           (rays (sort (make-unique
                        (delete
                         '(0 . 0)
                         (enumerate (iota w (- x)) (iota h y -1))))
                       (lambda (a b) (< (v-rad a) (v-rad b)))))
           (i 0))
    (while #t
      (letrec ((i' (modulo i (length rays)))
            (ray (list-ref rays i'))
            (vaporize
             (lambda (p ray)
               (let ((p' (weird-ray-add p ray)))
                 (if (inside w h p')
                     (begin
                     (if (hash-ref asteroid-map' p')
                         (begin
                           (hash-remove! asteroid-map' p')
                           p')
                         (vaporize p' ray)))
                     '()
                     ))))
            (vp (vaporize (cons x y) ray))
            )
        (if (not (null? vp))
            (set! vaporized (append vaporized (list vp))))
        (if (= (hash-count (const #t) asteroid-map') 1)
            (break))
        (set! i (1+ i))
        ))
    vaporized))
    
(letrec*
    ((input (problem-input))
     (width (length (car input)))
     (height (length input))
     (asteroid-map (make-hash-table))
     (asteroids '())
     (best-location
      (lambda (asteroids)
        (if (null? asteroids)
            (list -1 0 0)
            (let* ((x (caar asteroids))
                   (y (cdar asteroids))
                   (n (count-visible width height x y asteroid-map))
                   (best (best-location (cdr asteroids)))
                   (n' (car best)))
              (if (> n'  n)
                  best
                  (list n x y)))))))

  (enumerate-asteroids
   input
   (lambda (x y a)
     (if a (hash-set! asteroid-map (cons x y) #t))))

  (enumerate-asteroids
   input
   (lambda (x y a)
     (if a (set! asteroids (cons (cons x y) asteroids)))))

  (let* ((b (best-location asteroids))
         (loc (cons (cadr b) (caddr b)))
         (vaporized
          (rotate-laser width height (car loc) (cdr loc) asteroid-map))
         (200th (list-ref vaporized 199))
         (result (+ (* 100 (car 200th)) (cdr 200th))))
    (format #t "~a~%" result)))
