(define player%
  (class object%
    (init-field [name "Duns"]
                [stage 1]
                [next-stage #f]
                [win-cond #f]
                [second 0]
                [high-scores null]
                [output-port "high-score.txt"]
                [input-port "high-score.txt"]
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
    (define/public (get-sec)
      second)
    (define/public (get-min)
      (quotient second 60))
    (define/public (add-sec)
      (set! second (+ second 1)))
    (define/public (get-time) ;Matar ut tiden som sträng i formatet MM:SS
      (if (< (remainder (send player-stats get-sec) 60) 10)
          (string-append  (number->string (send player-stats get-min)) ":0" (number->string (remainder (send player-stats get-sec) 60))) 
          (string-append  (number->string (send player-stats get-min)) ":" (number->string (remainder (send player-stats get-sec) 60)))))
    (define/public (get-high-scores)
      high-scores)
    (define/public (save-high-scores)
      (let ((out (open-output-file output-port
                                   'can-update)))
        (display high-scores out)
        (close-output-port out)))
    (define/public (add-new-score! name&time) ;Tar in ett par och lägger till det i highscore-filen
      (set! high-scores (sort (cons name&time high-scores)
                              (lambda (x y) (< (cdr x) (cdr y))))))
    (define/public (load-high-scores!)
      (let ((in (open-input-file input-port)))
        (set! high-scores (read in))
        (set! high-scores (filter (lambda (x) (not (eof-object? x))) high-scores))
        ;        (set! high-scores (map (lambda (x) 
        ;                                 (cons (car x) 
        ;                                       (string-append (number->string (quotient (cdr x) 60)) ":" (number->string (remainder (cdr x) 60))))) 
        ;                               high-scores))
        (close-input-port in)))
    (super-new)))

(define (first-n n lst) ;Egen version av take-funktionen
  (cond ((null? lst) '())
        ((= n 0) '())
        (else (cons (car lst) (first-n (- n 1) (cdr lst))))))

(define player-stats (new player%))

(define next-window ;Mellan fönster som låter spelaren avsluta spelet, starta om nivån eller gå vidare till nästa.
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

(define start-window ;Startfönstret som låter spelaren skriva in sitt namn, kontrollera musiken och öppna ett hjälpfönster
  (lambda ()
    (begin
      (define window
        (new frame%
             [label "Welcome mortal!"]
             [width 500]
             [height 670]))
      
      (define tutorial-window
        (new frame%
             [label "Help"]
             [width 200]
             [height 50]))
      
      (define tutorial-message
        (new message%
             [parent tutorial-window]
             [label (string-append "Read everything all the information provided to you in every window.\n" 
                                   "Try to think outside the box.\n"
                                   "Some windows may require you to click on it to enable interactivity.\n"
                                   "C C G G A A G")]))
      
      (define canvas
        (new canvas%
             [parent window]
             [paint-callback (lambda (canvas dc)
;                               (send dc set-font (make-object font% 30 'default))
;                               (send dc draw-text "Welcome to" 50 30)
;                               (send dc draw-text "JayJay-WindowNavigation" 5 65)
;                               (send dc set-font (make-object font% 10 'default 'italic))
;                               (send dc draw-text "Try to navigate through our windows" 100 120)
;                               (send dc draw-text "A tip: Read everything shown to you on the windows." 50 140)
;                               (send dc draw-text "Enter your name below if you feel like it." 100 160)
;                               (send dc draw-bitmap (read-bitmap "elak.png") 210 250)
                               (send dc draw-bitmap (read-bitmap "inc.png") 0 0))])) ;Ersatte starttexten med en snyggare bild
      (define input-name
        (new text-field%
             [parent window]
             [label "Name:"]
             [callback (lambda (field event)
                         (when (eq? (send event get-event-type) 'text-field-enter)
                           (send player-stats set-name (send field get-value))))])) ;Denna inläsning sker även på startknappen för att spelaren inte ska vara tvungen att trycka enter
      
      
      (define start-button
        (new button%
             [parent window]
             [label "Click here to start"]
             [callback (lambda (button event)
                         (play-sound "tystnad.wav" #t)
                         (unless (eq? (send input-name get-value) "")
                           (send player-stats set-name (send input-name get-value))) ;Tomma textsträngar i Highscore skapar problem med inläsning senare
                         (send player-stats set-stage 1)
                         (send window show #f)
                         (run-window 1)
                         (game-timer-window))]))
      
      (define highscore
        (new message%
             [parent window]
             [label ""]
             [font (make-object font% 12 'default)]
             [auto-resize #t]))
      
      (define music
        (new button%
             [parent window]
             [label "Stop the music"]
             [callback (let ((t #t))
                         (lambda (button event)
                           (if t
                               (begin (play-sound "tystnad.wav" #t) ;Enda sättet som vi upptäckt att stoppa musik som spelas
                                      (send music set-label "Play"))
                               (begin (play-sound "Rap_King.wav" #t)
                                      (send music set-label "Stop the music")))
                           (set! t (not t))))]))
      
      (define tutorialbutton
        (new button%
             [parent window]
             [label "Some help"]
             [callback (lambda (button event)
                         (send tutorial-window show #t))]))
        
      
      (send player-stats load-high-scores!)
      (send highscore set-label ;Skriver ut de lägsta tiderna och deras spelarnamn i tabellform
            (let ((txt ""))
              (for-each (lambda (x)
                          (set! txt (string-append (symbol->string (car x)) 
                                                   "      " 
                                                   (string-append (number->string (quotient (cdr x) 60))
                                                                  ":" 
                                                                  (if (< (remainder (cdr x) 60) 10) 
                                                                      "0" "")
                                                                  (number->string (remainder (cdr x) 60))) 
                                                   "\n" 
                                                   txt))) 
                        (first-n 3 (send player-stats get-high-scores)))
              (string-append "   Highscore\nName      Time\n" txt)))
      (play-sound "Rap_King.wav" #t)
      (send window show #t))))

(define (start-next)
  (if (< (length *window-list*) (+ (send player-stats get-stage) 1))
      (begin (send player-stats set-win-cond #t)
             (send player-stats add-new-score! (cons (send player-stats get-name) (send player-stats get-sec)))
             (send player-stats save-high-scores)
             (winner-window))
      (next-window)))


(define game-timer-window ;Timerfönstet som skriver ut nya texter efterhand som tiden går
  (lambda ()
    (define window
      (new frame%
           [label "Go go, power rangers"]
           [width 300]
           [height 100]))
    
    (define gt-callback ;Timers funktion som uppdaterar texten i fönstret och ökar speltiden
      (lambda ()
        (when (send player-stats get-win-cond)
          (send game-timer stop)
          (send insult-message set-label "Congrats"))
        (send player-stats add-sec)
        (if (< (remainder (send player-stats get-sec) 60) 10)
            (send timer-display set-label 
                  (string-append  (number->string (send player-stats get-min)) 
                                  ":0" 
                                  (number->string (remainder (send player-stats get-sec) 60)))) 
            (send timer-display set-label 
                  (string-append  (number->string (send player-stats get-min)) 
                                  ":" 
                                  (number->string (remainder (send player-stats get-sec) 60)))))
        (cond ((< (send player-stats get-min) 1)
               (send insult-message set-label "You can take all the time you want, I'm just a computer."))
              ((< (send player-stats get-min) 2)
               (send insult-message set-label (string-append "I detect a scent of smoke... Are you trying to think "
                                                             (send player-stats get-name)
                                                             "?")))
              ((< (send player-stats get-min) 3)
               (send insult-message set-label (string-append "2 minutes have passed and you have only done " 
                                                             (number->string (send player-stats get-stage)) 
                                                             " levels.")))
              ((< (send player-stats get-min) 5)
               (send insult-message set-label "Roses are red. Violets are blue. We had a monkey do this test and he was faster than you"))
              (else 
               (send insult-message set-label "Time flies like an arrow, fruit flies like a banana")))))
    
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

(define winner-window ;Slutfönstret som har en trevlig slutanimation och skriver ut tiden och spelarens namn. Har även valmöjlighet att stänga av musiken och färgerna
  (lambda ()
    (let ((fun-factor #f))
      (define window (new frame% 
                          [width 500]
                          [height 500]
                          [label "A winner is you!"]
                          ))
      (define p-callback
        (lambda (canvas dc)
          (send dc translate 250 250)))
      (define canvas (new canvas%
                          [parent window]
                          [paint-callback p-callback]))
      (define rotations
        (new timer% [notify-callback (lambda ()
                                       (when fun-factor
                                         (send (send canvas get-dc) rotate (/ pi 180)))
                                       (send (send canvas get-dc) clear)
                                       (send (send canvas get-dc) draw-text (string-append "Congrats " 
                                                                                           (send player-stats get-name)
                                                                                           ", You clocked in at "
                                                                                           (send player-stats get-time))
                                             -150 0)
                                       (when fun-factor
                                         (send (send canvas get-dc) set-background (make-object color% (random 255) (random 255)(random 255))))
                                       
                                       )]))
      (define fun-button (new button% 
                              [parent window]
                              [label "I like fun and do not suffer from epilepsy"]
                              [callback (lambda (button event)
                                          (set! fun-factor (not fun-factor))
                                          (if fun-factor
                                              (begin (send fun-button set-label "I don't like this")
                                                     (play-sound "Rap_King.wav" #t))
                                              (begin (send fun-button set-label "I like fun and do not suffer from epilepsy")
                                                     (play-sound "tystnad.wav" #t))))]))
      
      (define exit-button (new button% 
                               [parent window]
                               [label "Exit"]
                               [callback (lambda (button event)
                                           (send window show #f)
                                           (play-sound "tystnad.wav" #t))]))
      
      (send window show #t)
      (send rotations start 10))))
