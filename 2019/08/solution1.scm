(use-modules (ice-9 rdelim))

(define (problem-input)
  (string->list (read-line)))

(define (count lst c)
  (if (null? lst)
      0
      (if (eqv? c (car lst))
          (1+ (count (cdr lst) c))
          (count (cdr lst) c))))

(define (split lst size)
  (if (> (length lst) size)
      (cons (list-head lst size) (split (list-tail lst size) size))
      (list lst)))


(define (find-layer layers c f)
  (let* ((layer (car layers))
         (n (count layer c)))
    (if (null? (cdr layers))
        (cons n layer)
        (let* ((layer' (find-layer (cdr layers) c f))
               (n' (car layer')))
          (if (f n n')
              (cons n layer)
              layer')))))

(let* ((image (problem-input))
       (width 25)
       (height 6)
       (layer-size (* width height))
       (layers (split image layer-size))
       (0-layer (cdr (find-layer layers #\0 <)))
       (n (* (count 0-layer #\1) (count 0-layer #\2))))
  (format #t "~a~%" n))
