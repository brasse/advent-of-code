(use-modules (ice-9 rdelim))

(define (problem-input)
  (let ((l (read-line))
        (read-moon
         (lambda (l)
           (let* ((l' (string-delete (char-set #\< #\> #\space) l))
                  (parts (string-split l' #\,))
                  (value
                   (lambda (s)
                     (string->number (cadr (string-split s #\=))))))
             (map value parts)))))
    (if (eof-object? l)
        '()
        (cons (read-moon l) (problem-input)))))

(define (comb m lst)
  (cond ((= m 0) '(()))
        ((null? lst) '())
        (else (append (map (lambda (y) (cons (car lst) y))
                           (comb (- m 1) (cdr lst)))
                      (comb m (cdr lst))))))

(define (apply-gravity m0 v0 m1 v1)
  (let* ((chk
         (lambda (m0' m1' axis)
           (let ((x0 (list-ref m0' axis))
                 (x1 (list-ref m1' axis)))
             (cond
              ((> x0 x1) -1)
              ((< x0 x1) 1)
              (else 0)))))
        (dv0 (map (lambda (axis) (chk m0 m1 axis)) (list 0 1 2)))
        (dv1 (map (lambda (axis) (chk m1 m0 axis)) (list 0 1 2)))
        (v0' (map + dv0 v0))
        (v1' (map + dv1 v1)))
    (list v0' v1')))

(let* ((moons (problem-input))
       (vs (make-list (length moons) '(0 0 0)))
       (steps 1000))
  (for-each
   (lambda (ignore)
     (map
      (lambda (pair)
        (let* ((i (car pair))
               (j (cadr pair))
               (delta-vs
                (apply-gravity
                 (list-ref moons i) (list-ref vs i)
                 (list-ref moons j) (list-ref vs j)))
               (vi (car delta-vs))
               (vj (cadr delta-vs)))
          (list-set! vs i vi)
          (list-set! vs j vj)))
      (comb 2 (iota (length moons))))
     (set! moons (map (lambda (p v) (map + p v)) moons vs)))
   (iota steps))

  (let* ((energy (lambda (v) (apply + (map abs v))))
         (total-energy
          (apply + (map * (map energy moons) (map energy vs)))))
    (format #t "~a~%" total-energy)))
