(use-modules (ice-9 rdelim))

(define (input)
  (list->vector (map string->number (string-split (read-line) #\,))))

(define (ind program pos)
  (vector-ref program (vector-ref program pos)))

(define (imm program pos)
  (vector-ref program pos))

(define (w program pos value)
  (vector-set! program pos value))

(define (run program noun verb)
  (let ((p 0))
    (vector-set! program 1 noun)
    (vector-set! program 2 verb)
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
      (set! p (+ p 4)))
    (vector-ref program 0)))

(define (find nouns verbs needle program)
  (letrec ((test-verbs
            (lambda (verbs noun)
              (if (null? verbs)
                  -1
                  (let* ((the-copy (vector-copy program))
                         (verb (car verbs))
                         (output (run the-copy noun verb)))
                    (if (= output needle)
                        verb
                        (test-verbs (cdr verbs) noun)))))))
    (if (null? nouns)
        -1
        (let ((verb (test-verbs verbs (car nouns))))
          (if (= verb -1)
              (find (cdr nouns) verbs needle program)
              (+ (* 100 (car nouns)) verb))))
    ))

(define nounverbe (find (iota 100) (iota 100) 19690720 (input)))
(display nounverbe)
(newline)
