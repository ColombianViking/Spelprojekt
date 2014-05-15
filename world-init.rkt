(load "panic.rkt")
(load "maze.rkt")
(load "piano.rkt")
(load "structure-windows.rkt")
(load "ball.rkt")
(load "boxworth.rkt")
(load "chesstime.rkt")
(load "mazeofspades.rkt")
(load "nextnumber.rkt")
(load "rebus.rkt")

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
(add-window! 5 chess)
(add-window! 6 boxworth)
(add-window! 7 riddle)
(add-window! 8 dodge)
(add-window! 9 rebus)


    
(define game-start
  (lambda ()
    (start-window)))
    
