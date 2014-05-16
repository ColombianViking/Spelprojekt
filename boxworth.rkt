(define boxworth
  (lambda ()
    
    (define window (new frame%
                        [width 500]
                        [height 500]
                        [label "Your first instinct is probably wrong"]
                        ))
    
    (define p-callback
      (lambda (canvas dc)
        (begin
          (send dc draw-bitmap (read-bitmap "marbles.png") 0 0)
          (send dc draw-rectangle 500 500 0 0)
          (send dc draw-text 
                "A box of marbels cost $20. If the marbles are " 90 250))
        (send dc draw-text 
              "valued at $19 more than the box" 120 280)
        (send dc draw-text "What is the box worth?" 170 310)))
    (define canvas (new canvas%
                        [parent window]
                        [paint-callback p-callback] 
                        ))
    
    (define t-callback
      (lambda (field event)
        (when (and (eq? (send event get-event-type) 'text-field-enter)
                   (or (equal? (send field get-value) "0.50")
                       (equal? (send field get-value) "0,50")
                       (equal? (send field get-value) "0.5")
                       (equal? (send field get-value) "0,5")
                       (equal? (send field get-value) "1/2")))
          (begin (send window show #f)
                 (start-next)))))
    
    (define text (new text-field%
                      [label "Answer:"]
                      [parent window]
                      [callback t-callback]))
    
    (send window show #t)))

