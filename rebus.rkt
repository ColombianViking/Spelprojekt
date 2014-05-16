(define rebus
  (lambda ()
    (define window (new frame%
                        [width 500]
                        [height 500]
                        [label "The Pet Detective"]
                        ))
    
    (define p-callback
      (lambda (canvas dc)
        (begin
          (send dc draw-bitmap (read-bitmap "butterface.png") 0 0)
          (send dc draw-rectangle 500 500 0 0))))
    
    (define canvas (new canvas%
                        [parent window]
                        [paint-callback p-callback] 
                        ))
    
    (define t-callback
      (lambda (field event)
        (when (and (eq? (send event get-event-type) 'text-field-enter)
                   (or (equal? (send field get-value) "butterface")
                       (equal? (send field get-value) "Butterface")))
          (send window show #f)
          (start-next))))
    
    (define text (new text-field%
                      [label "Password:"]
                      [parent window]
                      [callback t-callback]))
    
    (send window show #t)))