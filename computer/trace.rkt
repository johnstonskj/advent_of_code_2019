#lang racket/base

(require "_machine.rkt"
         racket/bool racket/file racket/format racket/list racket/string racket/vector)

(provide trace-enable trace-state trace-opcode trace-param traceln)

;; ----------------------------------------------------------------------------

(define *trace-enabled* #f)

;; ----------------------------------------------------------------------------

(define (trace-enable yesno)
  (set! *trace-enabled* yesno))

(define (trace-state machine)
  (when *trace-enabled*
    (display
     (format
      "/* ~a ~a ~a */  "
      (~a (machine-pc machine) #:min-width 5 #:right-pad-string " ")
      (~a (machine-state machine) #:min-width 8 #:right-pad-string " ")
      (~a (machine-error-code machine) #:min-width 2 #:right-pad-string "0")))))

(define (trace-opcode opcode)
  (when *trace-enabled*
    (display (~a opcode #:min-width 5 #:right-pad-string " "))
    (display " ")))

(define (trace-param param position)
  (when *trace-enabled*
    (if position
        (display "@")
        (display " "))
    (display (~a param #:min-width 4 #:right-pad-string " "))
    (display " ")))

(define (traceln)
  (when *trace-enabled*
    (displayln "")))
