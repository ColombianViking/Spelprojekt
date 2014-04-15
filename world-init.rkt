(load "panic.rkt")

(define *window-list* null)

(define add-window!
  (lambda (num window)
    (set! *window-list* (cons (cons num window) *window-list*))))

(define run-window
  (lambda (num)
    (when (pair? (assoc num *window-list*))
      ((cdr (assoc num *window-list*))))))

(add-window! 1 panic)