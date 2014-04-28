(load "game-canvas.rkt")

(define panic
  (lambda ()
    (begin
      (define window (new frame%
                          [width 500]
                          [height 500]
                          [label "kookokooko"]))
      (define canvas (new game-canvas%
                          [parent window]
                          [paint-callback (lambda (canvas dc)
                                             (begin
                                               (send dc draw-text "Don't panic" 210 210)
                                               (send dc draw-rectangle 200 300 100 100)
                                               (send dc draw-rectangle 50 100 200 30)
                                               ))]
                          [mouse-handler (lambda (mouse)
                                           (let ((mx (send mouse get-x)) (my (send mouse get-y)))
                                             (when (send mouse moving?)
                                               (send (send canvas get-dc) draw-rectangle 50 100 200 30)
                                               (send (send canvas get-dc) draw-text (string-append "y = " (number->string my) ", x = " (number->string mx)) 55 105))
                                             (define (start-win-timer)
                                               (display (send win-timer interval))
                                               (when (or (> 200 mx) (> 300 mx) (> 300 my) (< 400 my))
                                                 (display "SHIT")
                                                 ))
                                             (when (and (< 200 mx) (> 300 mx) (< 300 my) (> 400 my) (boolean? (send win-timer interval)))
                                                     (send (send canvas get-dc) draw-ellipse 400 50 10 10)
                                               )
                                             ))]
                          ))
      (define timer
        (let ((t 0))
          (lambda args
            (define update
              (lambda ()
                (if (= t 0)
                  (send updater stop)
                  (set! t (- t 1)))
                ))
            (define updater (new timer% [notify-callback update]))
            (cond ((null? args) t)
                  ((eq? (car args) start)
                   (send updater start 1000 #f))
                  ((eq? (car args) reset)
                   (send updater stop)
                   (set! t 0))
                  (else ())))))
      
      
      (define button (new button%
                          [parent window]
                          [label "Press 2 Win"]
                          [callback (lambda (button event)
                                      (send window show #f))]
                          ))   
      (send window show #t))))
                                 
