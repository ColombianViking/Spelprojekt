(load "game-canvas.rkt")

(define grass ;Fönster som vinns om spelaren inte lyckas klicka båda cirklarna utan att röra muspekaren över mitten delen
  (lambda ()
    (let ((mx 0) (my 0) (start-pressed #f))
      (define window
        (new frame%
             [label "Don't step on the grass"]
             [width 500]
             [height 500]
             ))
      
      (define p-callback
        (lambda (canvas dc)
         ;(send dc draw-text (string-append "x = " (number->string mx) ",y = " (number->string my)) 10 10)
          (if start-pressed ;Ritar ut en av cirklarna beroende på om den första blivit nedtryckt eller ej
              (begin (send dc set-brush "red" 'solid)
                     (send dc draw-ellipse 225 400 60 60)
                     (send dc draw-text "win" 235 420)
                     (send dc set-brush "green" 'solid))
              (begin (send dc set-brush "blue" 'solid)
                     (send dc draw-ellipse 225 50 60 60)
                     (send dc draw-text "start" 235 70)
                     (send dc set-brush "brown" 'solid)))
          (send dc draw-rectangle 0 150 500 200)
          (send dc set-brush "white" 'solid)))
      
      
      (define gcv
        (new game-canvas%
             [parent window]
             [paint-callback p-callback]
             [keyboard-handler (lambda (key) (void))]
             [mouse-handler 
              (lambda (mouse)
                (when (send mouse moving?)
                  (set! mx (send mouse get-x)) 
                  (set! my (send mouse get-y)))
                (when (and (send mouse button-down? 'left) ;Tracking av muskoordinater för att kunna veta vart spelaren klickar
                           (> mx 225) (< mx 285)
                           (> my 50) (< my 110)
                           (not start-pressed))
                  (set! start-pressed #t))
                (when (and (send mouse button-down? 'left)
                           (> mx 225) (< mx 285)
                           (> my 400) (< my 460)
                           start-pressed)
                  (send window show #f)
                  (start-next))
                (when (and (> my 150) (< my 350)
                           start-pressed)
                  (set! start-pressed #f))
                (send gcv refresh))
              ]))
      (send window show #t)
      
      )))