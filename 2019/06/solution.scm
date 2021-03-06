(use-modules (ice-9 rdelim))

(define (input)
  (letrec ((lines (lambda ()
                    (let ((l (read-line)))
                      (if (eof-object? l)
                          '()
                          (cons l (lines)))))))
    (map (lambda (line)
           (let ((parts (string-split line #\))))
             (cons (car parts) (cadr parts))))
         (lines))))

(define (make-orbits-map orbits)
  (letrec ((orbits-map (make-hash-table))
           (make (lambda (orbits)
                   (if (not (null? orbits))
                       (let* ((orbit (car orbits))
                              (lst (hash-ref orbits-map (car orbit) '())))
                         (hash-set!
                          orbits-map (car orbit) (cons (cdr orbit) lst))
                         (make (cdr orbits)))))))
    (make orbits)
    orbits-map))

(define  (make-orbit-tree orbit-map)
  (letrec ((make-orbit-tree'
            (lambda (name)
              (let ((satellites (hash-ref orbit-map name '())))
                (if (null? satellites)
                    (list name '())
                    (list name (map make-orbit-tree' satellites)))))))
    (make-orbit-tree' "COM")))

(define (orbit-checksum orbits)
  (let* ((satellites (cadr orbits))
         (sum (lambda (lst)
                (list
                 (+ (length satellites)
                    (apply + (map car lst)))
                 (+ (apply + (map cadr lst))
                    (apply + (map caddr lst)))
                 (+ (length satellites)
                    (apply + (map caddr lst)))))))
    (if (null? satellites)
        (list 0 0 0)
        (sum (map orbit-checksum satellites)))))

(let* ((orbit-tree (make-orbit-tree (make-orbits-map (input))))
       (checksum-parts (orbit-checksum orbit-tree))
       (n-direct (car checksum-parts))
       (n-indirect (cadr checksum-parts))
       (checksum (+ n-direct n-indirect)))
  (display checksum)
  (newline))

