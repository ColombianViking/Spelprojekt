(define game-canvas%
  (class canvas%
    (init-field [keyboard-handler display]
                [mouse-handler display])
    (define/override (on-char key-event)
      (keyboard-handler key-event))
    (define/override (on-event mouse-event)
      (mouse-handler mouse-event))
    (super-new)))

(define window (new frame%
                    [width 500]
                    [height 500]
                    [label "jojojo"]
                    ))
(define mouse-func
  (let ((t 0))
      (lambda (mouse)
        (when (< t 0)
          (set! t (- 0 t)))
        (cond ((send mouse button-down? 'left)
               (send (send game-c get-dc) draw-ellipse 10 10 t t)
               (set! t (+ t 10)))
              ((send mouse button-down? 'right)
               (send (send game-c get-dc) draw-ellipse t t 10 10)
               (set! t (- t 10)))
              (else (void))))))
            

(define game-c (new game-canvas%
                    [parent window]
                    [paint-callback (lambda (canvas dc) (send dc draw-rectangle 240 240 20 20))]
                    [mouse-handler mouse-func]))

(send window show #t)