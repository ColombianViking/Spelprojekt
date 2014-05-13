(load "game-canvas.rkt")

(define ballball
  (lambda ()
    (define window
      (new frame%
           [label "Yep, this is the most boring window of them all"]
           [width 500]
           [height 500]
           ))
        
    (define k-handler
      (lambda (k-ev)
        (let ((key (send k-ev get-key-code))) 
          (cond ((eq? 'left key)
                 (send baller move -5 0))
                ((eq? 'right key)
                 (send baller move 5 0))
                ((eq? 'up key)
                 (send baller move 0 -5))
                ((eq? 'down key)
                 (send baller move 0 5))
                (else (void))))))
    
    (define p-callback
      (lambda (canvas dc)
        (let* ((loc (send baller get-loc)) (x (car loc)) (y (cdr loc)))
          ;(send dc draw-bitmap (read-bitmap "pilar.png") 0 0)
          (send dc draw-text "x^2 y-250 x^2-600 x y+150000 x+90000 y-22500000 = 0" 15 30)
          (send dc draw-rectangle 50 100 200 30)
          (send dc draw-text (string-append "y = " (number->string (send baller get-y)) ", x = " (number->string (send baller get-x))) 55 105)
          (send dc set-brush "yellow" 'solid)
          (send dc draw-ellipse x y 10 10))))
    
    (define gcv
      (new game-canvas%
           [parent window]
           [paint-callback p-callback]
           [mouse-handler (lambda (x) (void))]
           [keyboard-handler k-handler]))
    
    (define ball%
      (class object%
        (init-field
         [start (cons 0 0)]
         [x 0]
         [y 0]
         [status 'dead])
        (define/public (get-x)
          x)
        (define/public (get-y)
          y)
        (define/public (get-loc)
          (cons x y))
        (define/public (get-status)
          status)
        (define/public (set-status new-stat)
          (set! status new-stat))
        (define/public (set-x nx)
          (set! x nx))
        (define/public (set-y ny)
             (set! y ny))
        (define/public (move dx dy)
          (unless (>= 0 (+ x dx))
            (set! x (+ x dx)))
          (unless (>= 0 (+ y dy))
            (set! y (+ y dy)))
         ; (send ball draw)
          )
        (define/public (draw)
          (send gcv refresh))
        (define/public (respawn)
          (set! x (car start))
          (set! y (cdr start))
          ;(send ball draw)
          )
        (super-new)))
    
    (define baller 
      (new ball%
           [start (cons 10 250)]
           [y 250]
           [x 10]
           [status 'alive]))
    
    (define graph-update
      (new timer%
           [notify-callback (lambda ()
                                (send gcv refresh)
                              (when (and (< (abs (- (send baller get-x) 250)) 3) (< (abs (- (send baller get-y) 300)) 3))
                                (send baller respawn)
                                (new button%
                                     [label "OH"]
                                     [parent window]
                                     [callback (lambda (button event) (start-next))]
                                     )))]))
    
    (send window show #t)
    (send baller draw)
    (send graph-update start 20)))