
(define maze ;maze öppnar förnstret till nivå 1
  (lambda ()
    (define window (new frame%
                        [width 500]
                        [height 500]
                        [label "Maze of doom"]
                        ))
    
    (define p-callback
      (lambda (canvas dc)
        (begin
          (send dc draw-bitmap (read-bitmap "maze.png") 0 0)
          (send dc draw-rectangle 500 500 0 0))))
    (define canvas 
      (new canvas%
           [parent window]
           [paint-callback p-callback] 
           ));skapar canvasen och kallar på bitmaps
    
    (define t-callback
      (lambda (field event)
        (when (and (eq? (send event get-event-type) 'text-field-enter)
                   (or (equal? (send field get-value) "BH")
                       (equal? (send field get-value) "bh")
                       (equal? (send field get-value) "B H")
                       (equal? (send field get-value) "b h")))
          (begin (send window show #f)
                       (start-next)))));funktionen kontrollerar om spelaren har rätt svar
                              
    (define text (new text-field%
                      [label "Next password is:"]
                      [parent window]
                      [callback t-callback]));skapar textfönster
    
    (send window show #t)))
