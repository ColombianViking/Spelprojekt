(define riddle
  (lambda ()
    (define window (new frame%
                        [width 500]
                        [height 500]
                        [label "One Move"]
                        ))
    
(define p-callback
      (lambda (canvas dc)
        (begin
          (send dc draw-bitmap a-bitmap 0 0)
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
        (displayln (string? (send field get-value)))
        (when (and (eq? (send event get-event-type) 'text-field-enter)
                   (equal? (send field get-value) "c7c8"))
          (send window show #f))))
                              
    (define text (new text-field%
                      [label "XY"]
                      [parent window]
                      [callback t-callback]))
 
    
    (send window show #t)))

(define bitmap-canvas%
  (class canvas%
    (init-field [bitmap #f])
    (inherit get-dc)
    (define/override (on-paint)
      (send (get-dc) draw-bitmap bitmap 0 0))
    (super-new)))
(define a-bitmap (read-bitmap "chess.png"))
(define f (new frame% 
               [label "en bild"] 
               [width 500] 
               [height 500]))
(define the-canvas (new bitmap-canvas% 
                        [parent f] 
                        [bitmap a-bitmap]))

(define (bild) (send f show #t))
