(load "game-canvas.rkt")

(define panic
  (lambda ()
    (begin
      (define window (new frame%
                          [width 500]
                          [height 500]
                          [label "Tick tock on the clock"]))
      
      (define panic-font (make-object font% 40 'default))
      (define win-text "")
      
      (define canvas (new game-canvas%
                          [parent window]
                          [paint-callback (lambda (canvas dc)
                                            (let ((dx (random 5)) (dy (random 5)))
                                             (begin
                                               (send dc set-font panic-font)
                                               (send dc draw-text "DON'T PANIC" (+ 80 dx) (+ 200 dy))
                                               (send dc draw-rectangle 200 300 100 100)
                                               (send dc set-font (make-object font% 8 'default 'italic))
                                               (send dc draw-text "Chillzone" 220 330)
                                               ;(send dc draw-rectangle 50 100 200 30)
                                               (send dc set-font (make-object font% 12 'default))
                                               (send dc draw-text win-text 230 10)
                                               )))]
                          [mouse-handler (lambda (mouse)
                                           (let ((mx (send mouse get-x)) (my (send mouse get-y)))
                                             (when (and (send mouse moving?) (or (> 200 mx) (< 300 mx) (> 300 my) (< 400 my)))
                                               (send canvas refresh))
                                                                                            
                                             (when (or (> 200 mx) (< 300 mx) (> 300 my) (< 400 my))
                                               (timer 'reset))
                                           
                                             (when (and (< 200 mx) (> 300 mx) (< 300 my) (> 400 my))
                                               (timer 'start))
                                             ))]
                          ))
      
      (define timer
        (let* ((t 0) (n 5) (updater (new timer% [notify-callback (lambda ()
                                                                    (when (= n 0)
                                                                      (set! win-text "funny face"))
                                                                    (set! t (+ t 1))
                                                                    (set! n (- n 1))
                                                                    (set! panic-font (make-object font% (abs (- 40 (* t 2))) 'default))
                                                                    (send canvas refresh))])))
          (lambda args 
            (cond ((null? args) t)
                  ((eq? (car args) 'start)
                   (send updater start 1000))
                  ((eq? (car args) 'reset)
                   (set! t 0)
                   (set! n 10)
                   (send updater stop))
                  ((eq? (car args) 'stop)
                   (send updater stop))
                  (else (void))))))
      
          (define t-callback
            (lambda (field event)
              (when (and (eq? (send event get-event-type) 'text-field-enter)
                         (equal? (send field get-value) "funny face"))
                (begin (send window show #f)
                       (start-next)))))
          
          (define text (new text-field%
                            [label "Password:"]
                            [parent window]
                            [callback t-callback]))
          (send canvas set-canvas-background (make-object color% "yellow"))
          (send window show #t))))
