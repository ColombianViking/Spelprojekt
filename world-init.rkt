(load "panic.rkt")

(define *window-list* null)

(define add-window!
  (lambda (num window)
    (set! *window-list* (cons (cons num window) *window-list*))))

(define run-window
  (lambda (num)
    (when (pair? (assoc num *window-list*))
      ((cdr (assoc num *window-list*))))))

(define random-list-generator
  (let ((n 10) (lst null))
    (define (loop)
      (if (= n 0)
          lst
          (begin (set! lst (cons (random 10) lst))
                 (set! n (- n 1))
                 (loop))))
    (loop)
    (remove-duplicates lst)
    (length lst)))
          
