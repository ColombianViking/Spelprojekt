
(define riddle
  (lambda ()    
    (define window (new frame%
                        [width 500]
                        [height 500]
                        [label "3, 76, 49, 24, 59, 36, 44"]
                        ))
    
    (define p-callback
      (lambda (canvas dc)
        (begin
          (send dc draw-bitmap (read-bitmap "umpa.png") 0 0)
          (send dc draw-rectangle 500 500 0 0)
          (send dc draw-text "Find the next number in the following sequence" 60 180)
          (send dc draw-text "3, 76, 49, 24, 59, 36" 150 270))))
    (define canvas (new canvas%
                        [parent window]
                        [paint-callback p-callback] 
                        ))
    
    (define t-callback
      (lambda (field event)
        (when (and (eq? (send event get-event-type) 'text-field-enter)
                   (equal? (send field get-value) "44"))
          (begin (send window show #f)
                       (start-next)))))
                              
    (define text (new text-field%
                      [label "Next number is:"]
                      [parent window]
                      [callback t-callback]))
    
    (send window show #t)))

