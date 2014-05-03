
(define riddle
  (lambda ()
    (define window (new frame%
                        [width 500]
                        [height 500]
                        [label "Riddle me this"]
                        ))
    
    (define p-callback
      (lambda (canvas dc)
        (begin
          (send dc draw-rectangle 500 500 0 0)
          (send dc draw-text "Why did the chicken cross the road" 125 210))))
    (define canvas (new canvas%
                        [parent window]
                        [paint-callback p-callback]
                        ))
    
    (define t-callback
      (lambda (field event)
        (displayln (string? (send field get-value)))
        (when (and (eq? (send event get-event-type) 'text-field-enter)
                   (equal? (send field get-value) "hiphop"))
          (send window show #f))))
                              
    (define text (new text-field%
                      [label "lemme see"]
                      [parent window]
                      [callback t-callback]))
    
    (send window show #t)))


    
