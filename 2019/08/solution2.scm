(use-modules (ice-9 rdelim) (ice-9 string-fun))

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

(define (decode-pixel pixel)
  (if (null? (cdr pixel))
      (car pixel)
      (if (eqv? #\2 (car pixel))
          (decode-pixel (cdr pixel))
          (car pixel))))

(define (decode-image layers)
  (if (null? (car layers))
      '()
      (cons (decode-pixel (map car layers))
            (decode-image (map cdr layers)))))

(let* ((image (problem-input))
       (width 25)
       (height 6)
       (layer-size (* width height))
       (layers (split image layer-size))
       (decoded-image (decode-image layers))
       (rows (split decoded-image width))
       (readable-rows
        (map
         (lambda (row)
           (string-replace-substring (list->string row) "0" " "))
         rows)))
  (for-each
   (lambda (row)
     (format #t "~a~%" row))
   readable-rows))
