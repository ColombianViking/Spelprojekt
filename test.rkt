(define window
  (new frame%
       [label "lo2l"]
       [width 500]
       [height 500]))

(define cvs
  (new canvas%
       [parent window]
       [paint-callback
        (lambda (canvas dc)
          (send dc draw-bitmap (make-object bitmap% "Exempelbild.png" 'png) 220 220))]))

(send window show #t)