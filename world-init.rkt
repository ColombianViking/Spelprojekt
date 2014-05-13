(load "panic.rkt")
(load "maze.rkt")
(load "piano.rkt")
(load "structure-windows.rkt")
(load "ball.rkt")

(define *window-list* null)

(define add-window!
  (lambda (num window)
    (set! *window-list* (cons (cons num window) *window-list*))))

(define run-window
  (lambda (num)
    (when (pair? (assoc num *window-list*))
      ((cdr (assoc num *window-list*))))))

(add-window! 1 maze)
(add-window! 2 panic)
(add-window! 3 piano)
(add-window! 4 ballball)
    
(define game-start
  (lambda ()
    (start-window)))
    
