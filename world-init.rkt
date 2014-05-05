(load "panic.rkt")

(define *window-list* null)

(define add-window!
  (lambda (num window)
    (set! *window-list* (cons (cons num window) *window-list*))))

(define run-window
  (lambda (num)
    (when (pair? (assoc num *window-list*))
      ((cdr (assoc num *window-list*))))))

(define next-win
  (lambda ()
    (define window
      (new frame%
           [height 500]
           [width 500]
           [label "A WINNER IS YOU"]
           ))
    
    (define p-callback
      (lambda (canvas dc)
        (send dc draw-rectangle 120 230 10 100)
        (send dc draw-text "Fönstret är avklarat" 170 190)))
    
    (define cv
      (new canvas%
           [parent window]
           [paint-callback p-callback]))
    
    (define center-pane (new horizontal-pane%
                           [parent window]
                           [alignment '(center center)]))
    
    (define exit-button
      (new button%
           [parent center-pane]
           [label "Exit"]
           [callback (lambda (button event)
                       (send window show #f))]))
    
    (define replay-button
      (new button%
           [parent center-pane]
           [label "Replay"]
           [callback (lambda (button event)
                       (send button set-label (send exit-button get-label)))]))
    
    (define next-button
      (new button%
           [parent center-pane]
           [label "Next"]
           [callback (lambda (button event)
                       (send button set-label (send exit-button get-label)))]))
    (send window show #t)))
    

           
