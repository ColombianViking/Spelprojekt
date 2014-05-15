(define chess
  (lambda ()
    (define window (new frame%
                        [width 500]
                        [height 500]
                        [label "One Move"]
                        ))
    
    (define p-callback
      (lambda (canvas dc)
        (begin
          (send dc draw-bitmap (read-bitmap "chess.png") 0 0)
          (send dc draw-rectangle 500 500 0 0)
          (send dc draw-text 
                "X" 170 350))
        (send dc draw-text "Y" 360 350)))
    (define canvas (new canvas%
                        [parent window]
                        [paint-callback p-callback] 
                        ))
    
    (define t-callback
      (lambda (field event)
        (when (and (eq? (send event get-event-type) 'text-field-enter)
                   (or (equal? (send field get-value) "c7c8")
                       (equal? (send field get-value) "C7C8")
                       (equal? (send field get-value) "c7 c8")
                       (equal? (send field get-value) "C7 C8")))
          (begin (send window show #f)
                 (start-next)))))
    
    (define text (new text-field%
                      [label "XY"]
                      [parent window]
                      [callback t-callback]))
    
    
    (send window show #t)))


