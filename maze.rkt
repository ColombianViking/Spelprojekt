(load "game-canvas.rkt")

(define dodge
  (lambda ()
    (define window
      (new frame%
           [label "What Anybody Should Do"]
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
                 (send baller move 0 -5)
                 (send balla move 0 -5))
                ((eq? 'down key)
                 (send baller move 0 5)
                 (send balla move 0 5))
                ((eq? #\a key)
                 (send balla move -5 0))
                ((eq? #\d key)
                 (send balla move 5 0))
                ((eq? #\w key)
                 (send balla move 0 -5))
                ((eq? #\s key)
                 (send balla move 0 5))
                (else (void))))))
    
    (define p-callback
      (lambda (canvas dc)
        (let* ((loc (send baller get-loc)) (x (car loc)) (y (cdr loc)) (2loc (send balla get-loc)) (2x (car 2loc)) (2y (cdr 2loc)))
          (send dc set-brush "black" 'solid)
          (send dc draw-rectangle 0 0 500 500)
          (send (send gcv get-dc) set-brush "blue" 'solid)
          (send dc draw-rectangle 0 0 500 230)
          (send dc draw-rectangle 0 270 500 230)
          (send dc set-brush "white" 'solid)
          (send dc draw-rectangle 460 230 10 40)
          (send dc draw-text "Get to the finish-line, control your ball with the arrowkeys." 50 300)
          (send (send gcv get-dc) set-brush "yellow" 'solid)
          (send (send gcv get-dc) draw-ellipse x y 10 10)
          (send (send gcv get-dc) set-brush "red" 'solid)
          (send (send gcv get-dc) draw-ellipse 2x 2y 10 10))))
    
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
    (define balla 
      (new ball%
           [start (cons 250 250)]
           [y 250]
           [x 250]
           [status 'alive]))
    
    (define graph-update
      (new timer%
           [notify-callback (lambda ()
                              (let* ((loc (send baller get-loc)) (x (car loc)) (y (cdr loc)) (2loc (send balla get-loc)) (2x (car 2loc)) (2y (cdr 2loc)))
                                (when (or (< y 230) (> y 260))
                                  (send baller respawn))
                                (when (or (< 2y 230) (> 2y 260))
                                  (send balla respawn))
                                (when (and (< (abs (- 2x x)) 10) (< (abs (- 2y y)) 10))
                                  (send baller respawn)
                                  (send balla respawn))
                                (when (> x 460)
                                  (send baller respawn)
                                  (send window show #f)
                                  (start-next))
                                (send gcv refresh)))]))
    
    (send window show #t)
    (send baller draw)
    (send graph-update start 20)))
           
                          