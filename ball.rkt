(load "game-canvas.rkt")
(require math/number-theory) ;Behövs för att kunna beräkna absolutbeloppet

(define ballball
  (lambda ()
    (define window
      (new frame%
           [label "LOCATION LOCATION LOCATION"]
           [width 500]
           [height 500]
           ))
        
    (define k-handler
      (lambda (k-ev)
        (let ((key (send k-ev get-key-code))) ;Kontroller för bollen
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
        (let* ((loc (send baller get-loc)) 
               (x (car loc)) 
               (y (cdr loc)) 
               (answer-dist (integer-root (+ (expt (- x 10) 2) 
                                             (expt (- y 300) 2)) ;Längden från det rätta svaret
                                          2)))
          (send dc draw-bitmap (read-bitmap "pilar.png") 0 0)
          (send dc draw-text "(XX) = XYYX" 215 30)
          (send dc set-font (make-object font% 8 'default))
          (send dc draw-text "Y" 243 21)
          (send dc set-font (make-object font% 12 'default))
          (send dc set-brush "cyan" 'solid)
          (send dc draw-rectangle 50 100 220 30)
          (send dc draw-text "y * 100 = ? , x * 10 = ?" 55 105)
          (if (< answer-dist 255)
              (send dc set-brush (make-object color% answer-dist 255 answer-dist) 'solid) ;Gör fönstret för x,y koordinaterna grönare ju närmare man kommer rätt koordinater
              (send dc set-brush "white" 'solid))
          (send dc draw-rectangle 50 140 220 30)
          (send dc draw-text (string-append "y = " (number->string y) ", x = " (number->string x)) 55 145)
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
           [x 250]
           [status 'alive]))
    
    (define graph-update
      (new timer%
           [notify-callback (lambda ()
                                (send gcv refresh)
                              (when (and (< (abs (- (send baller get-x) 10)) 3) (< (abs (- (send baller get-y) 300)) 3))
                                ;(send baller respawn) ;Denna rad kan läggas till för att inte massvis med knappar ska skapas när man står på rätt koordinater
                                (new button%
                                     [label "NICE"]
                                     [parent window]
                                     [callback (lambda (button event) 
                                                 (send window show #f) 
                                                 (start-next))]
                                     )))]))
    
    (send window show #t)
    (send baller draw)
    (send graph-update start 16)))