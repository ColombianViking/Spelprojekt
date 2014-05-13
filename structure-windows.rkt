(define player%
  (class object%
    (init-field [name "Duns"]
                [stage 1]
                [next-stage #f]
                [win-cond #f]
                )
    (define/public (get-name)
      name)
    (define/public (set-name new-name)
      (set! name new-name))
    (define/public (get-stage)
      stage)
    (define/public (set-stage new-stage)
      (set! stage new-stage))
    (define/public (get-next-stage)
      next-stage)
    (define/public (set-next-stage able)
      (set! next-stage able))
    (define/public (get-win-cond)
      win-cond)
    (define/public (set-win-cond able)
      (set! win-cond able))
    (super-new)))

(define player-stats (new player%))

(define next-window
  (lambda ()
    (define window
      (new frame%
           [height 500]
           [width 500]
           [label (string-append "You rock, " (send player-stats get-name))]
           ))
    
    (define p-callback
      (lambda (canvas dc)
        (send dc draw-rectangle 120 230 10 100)
        (send dc draw-text "Window navigated" 170 190)))
    
    (define cv
      (new canvas%
           [parent window]
           [paint-callback p-callback]))
    
    (define center-pane (new horizontal-pane%
                             [parent window]
                             [alignment '(center center)]))
    
    (define exit-button
      (new button%
           [parent center-pane]
           [label "Exit"]
           [callback (lambda (button event)
                       (send window show #f))]))
    
    (define replay-button
      (new button%
           [parent center-pane]
           [label "Replay"]
           [callback (lambda (button event)
                       (send window show #f)
                       (run-window (send player-stats get-stage)))]))
    
    (define next-button
      (new button%
           [parent center-pane]
           [label "Next"]
           [callback (lambda (button event)
                       (send window show #f)
                       (send player-stats set-stage (+ (send player-stats get-stage) 1))
                       (run-window (send player-stats get-stage))
                       )]))
    (send window show #t)))

(define start-window
  (lambda ()
    (begin
      (define window
        (new frame%
             [label "Welcome mortal!"]
             [width 500]
             [height 500]))
      
      (define canvas
        (new canvas%
             [parent window]
             [paint-callback (lambda (canvas dc)
                               (send dc set-font (make-object font% 30 'default))
                               (send dc draw-text "Welcome to" 50 30)
                               (send dc draw-text "JayJay-WindowNavigation" 5 65)
                               (send dc set-font (make-object font% 10 'default 'italic))
                               (send dc draw-text "Try to navigate through our windows" 100 120)
                               (send dc draw-text "A tip: Read everything shown to you on the windows." 50 140)
                               (send dc draw-text "Enter your name below if you feel like it." 100 160))]))
            (define input-name
        (new text-field%
             [parent window]
             [label "Name:"]
             [callback (lambda (field event)
                         (when (eq? (send event get-event-type) 'text-field-enter)
                           (send player-stats set-name (send field get-value))))]))
      (define middle
        (new horizontal-pane%
             [parent window]
             [alignment '(center center)]))   
            

  
      (define start-button
        (new button%
             [parent middle]
             [label "Click here to start"]
             [callback (lambda (button event)
                         (send player-stats set-stage 1)
                         (send window show #f)
                         (run-window 1)
                         (game-timer-window))]))
      (display (send player-stats get-stage))
      (send window show #t))))

(define (start-next)
  (if (< (length *window-list*) (+ (send player-stats get-stage) 1))
      (begin (send player-stats set-win-cond #t)
             (winner-window))
      (next-window)))


(define game-timer-window
  (lambda ()
    (define window
      (new frame%
           [label "Go go, power rangers"]
           [width 300]
           [height 100]))
    
    (define gt-callback
      (let ((t 0) (minute 0))
        (lambda ()
          (when (send player-stats get-win-cond)
            (send game-timer stop)
            (send insult-message set-label "Congrats"))
          (set! t (+ t 1))
          (when (= t 60)
            (set! minute (+ minute 1))
            (set! t 0))
          (if (< t 10)
              (send timer-display set-label (string-append  (number->string minute) ":0" (number->string t))) 
              (send timer-display set-label (string-append  (number->string minute) ":" (number->string t))))
          (cond ((< minute 1)
                 (send insult-message set-label "Time to use your grey matter"))
                ((< minute 2)
                 (send insult-message set-label "I detect a scent of smoke... Are you trying to think?"))
                ((< minute 3)
                 (send insult-message set-label "The primary analysis of your performance are just in! They say that you smell."))
                (else (send insult-message set-label "If you want to complete before the foundations of the UNIX-system break down, you better get a move on."))))))
    
    (define timer-display
      (new message%
           [label "0:00"]
           [parent window]
           [font (make-object font% 32 'default)]
           [auto-resize #t]))
    
    (define insult-message
      (new message%
           [label ""]
           [parent window]
           [font (make-object font% 15 'default)]
           [auto-resize #t]))
    
    (define game-timer
      (new timer%
           [notify-callback gt-callback]))
    (send game-timer start 1000)
    (send window show #t)
    ))

(define winner-window
  (lambda ()
    (define window (new frame% 
                        [width 500]
                        [height 500]
                        [label "Fett fränt, frände"]
                        ))
    (define p-callback
      (lambda (canvas dc)
        (send dc translate 250 250)
        (send dc draw-rectangle -25 -25 50 50)))
    (define canvas (new canvas%
                        [parent window]
                        [paint-callback p-callback]))
    (define rotations
      (new timer% [notify-callback (lambda ()
                                     (send (send canvas get-dc) rotate 1)
                                     (send (send canvas get-dc) draw-rectangle -25 -25 50 50)
                                     (send (send canvas get-dc) draw-text "LOL" -10 -10) 
                                     )]))
    (define button (new button% 
                        [parent window]
                        [label "Exit"]
                        [callback (lambda (button event)
                                    (send window show #f))]))
    (send window show #t)
    (send rotations start 200)))
