(define piano ;Fönster som vinns när spelaren spelar blinka lilla stjärna
  (lambda ()
    (let ((playlist '()))
    
    (define window
      (new frame%
           [label "Like a diamond in disguise"] ;Like a diamond in the sky
           [width 500]
           [height 500]))
    
    (define middle-frame
      (new horizontal-pane%
           [parent window]
           [alignment '(center center)]))
    
    (define (list-to-7string lst) ;Funktion som tar in en lista och ger ut en sträng med de första 7 elementen
      (let ((n 7) (res "") (t 0))
        (when (< (length lst) 7)
          (set! n (length lst)))
        (define (loop)
          (if (= n t)
              res
              (begin (set! res (string-append res " " (list-ref lst t)))
                     (set! t (+ t 1))
                     (loop))))
        (loop)))
    
    (define (add-last lst element) ;Sjukt snygg funktion som lägger till ett element i slutet av en lista
      (reverse (cons element (reverse lst))))
    
    (define (button-creator sound label-text) ;Funktion för att snabbt skapa ton-knapparna. Tar in adressen till en ljudfil och texten som ska vara på knappen 
                                              ;och lägger ut den på mittpanelen i fönstret
      (new button%
           [parent middle-frame]
           [label label-text]
           [callback (lambda (button event)
                       (play-sound sound #t)
                       (if (< (length playlist) 7)
                           (set! playlist (add-last playlist label-text))
                           (set! playlist (add-last (cdr playlist) label-text)))
                           
                           (send playback set-label (list-to-7string playlist))
                       (when (equal? playlist (list "C" "C" "G" "G" "A" "A" "G")) ;Tonföjlden för att spela låten 
                         (send window show #f)
                         (start-next))
                       )]))
    
    (define playback ;Text för att se vilka noter man har spelat
      (new message%
           [label ""]
           [parent window]
           [font (make-object font% 12 'default)]
           [auto-resize #t]))
    
    (button-creator "G.wav" "B")
    (button-creator "A.wav" "C")
    (button-creator "B.wav" "D")
    (button-creator "C.wav" "E")
    (button-creator "D.wav" "F")
    (button-creator "E.wav" "G")
    (button-creator "F.wav" "A")
    
    
    (send window show #t))))