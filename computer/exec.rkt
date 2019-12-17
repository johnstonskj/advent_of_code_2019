#lang racket/base

(require
  "core.rkt" "error.rkt" "gpio.rkt" "trace.rkt" "_machine.rkt"
  racket/bool racket/file racket/format racket/list racket/string racket/vector)

(provide execute)

;; ----------------------------------------------------------------------------

(define (execute machine
                 #:start [start 0]
                 #:trace [enabled #f])
  (trace-enable enabled)
  (set-machine-pc! machine start)
  (set-machine-state! machine 'running)
  (do () ((not (symbol=? (machine-state machine) 'running)))
    (execute-instruction machine)
    (clock-tick machine)))

;; ----------------------------------------------------------------------------

(define (clock-tick machine)
  (set-machine-clock! machine (+ (machine-clock machine) 1)))

(define (param-iref machine i)
  (let ([param (core-ref (machine-core machine) (+ (machine-pc machine) i))])
    (trace-param param #t)
    param))

(define (param-ref machine modes i)
  (let* ([c (+ (machine-pc machine) i)]
         [mode (if (>= (length modes) i)
                   (cond
                     [(= i 1) (first modes)]
                     [(= i 2) (second modes)]
                     [(= i 3) (third modes)]
                     [(= i 4) (fourth modes)]
                     [else (error-interrupt 3 "invalid opcode mode ref" i)])
                   0)]
         [immediate (core-ref (machine-core machine) c)])
    (cond
      [(= mode *opcode-mode-position*)
       (trace-param immediate #t)
       (core-ref (machine-core machine) immediate)]
      [(= mode *opcode-mode-immediate*)
       (trace-param immediate #f)
       immediate]
      [else (error-interrupt 3 "invalid opcode mode" mode)])))

(define *instructions*
  (hash
   0 (λ (modes machine)
        (trace-opcode "NOOP")
        1)
   1 (λ (modes machine)
       (trace-opcode "ADD")
       (let ([xv (param-ref machine modes 1)]
             [yv (param-ref machine modes 2)]
             [result (param-iref machine 3)])
         (core-set! (machine-core machine) result (+ xv yv)))
       4)
   2 (λ (modes machine)
       (trace-opcode "MUL")
       (let ([xv (param-ref machine modes 1)]
             [yv (param-ref machine modes 2)]
             [result (param-iref machine 3)])
         (core-set! (machine-core machine) result (* xv yv)))
       4)
   3 (λ (modes machine)
       (trace-opcode "INP")
       (let ([result (param-iref machine 1)])
         (let ([input (pin-read (machine-pins machine))])
           (unless (number? input)
             (error-interrupt 4 "invalid input" input))
           (core-set! (machine-core machine) result input)))
       2)
   4 (λ (modes machine)
       (trace-opcode "OUT")
       (let ([result (param-iref machine 1)])
         (pin-write (core-ref (machine-core machine) result) (machine-pins machine)))
       2)
   5 (λ (pc modes machine)
       (trace-opcode "JIFT")
       (let ([test (param-ref machine modes 1)]
             [newpc (param-ref machine modes 2)])
         (cond
           [(not (= test 0))
            (set-machine-pc! machine newpc)
            0]
           [else 2])))
   6 (λ (modes machine)
       (trace-opcode "JIFF")
       (let ([test (param-ref machine modes 1)]
             [newpc (param-ref machine modes 2)])
         (cond
           [(= test 0)
            (set-machine-pc! machine newpc)
            0]
           [else 2])))
   7 (λ (modes machine)
       (trace-opcode "LT")
       (let ([left (param-ref machine modes 1)]
             [right (param-ref machine modes 2)]
             [result (param-iref machine 3)])
         (cond
           [(< left right)
            (core-set!(machine-core machine)  result 1)]
           [else (core-set! (machine-core machine) result 0)]))
       4)
   8 (λ (modes machine)
       (trace-opcode "EQ")
       (let ([left (param-ref machine modes 1)]
             [right (param-ref machine modes 2)]
             [result (param-iref machine 3)])
         (cond
           [(= left right)
            (core-set! (machine-core machine) result 1)]
           [else (core-set! (machine-core machine) result 0)]))
       4)
   ))

(define *opcode-halt* 99)

(define *opcode-mode-position* 0)

(define *opcode-mode-immediate* 1)

(define *char-zero* (char->integer #\0))

(define (decode-opcode opcode)
  (let-values ([(modes opcode) (quotient/remainder opcode 100)])
    (values
     opcode
     (map
      (λ (c) (- (char->integer c) *char-zero*))
      (reverse (string->list (number->string modes)))))))

(define (execute-instruction machine)
  (traceln)
  (let* ([current-pc (machine-pc machine)]
         [opcode (core-ref (machine-core machine) current-pc)])
    (let-values ([(opcode modes) (decode-opcode opcode)])
      (trace-state machine)
      (cond
        [(= opcode *opcode-halt*)
         (trace-opcode "HALT")
         (set-machine-state! machine 'halted)]

        [(hash-has-key? *instructions* opcode)
         (let* ([instruction (hash-ref *instructions* opcode)]
                [pc-offset (instruction modes machine)])
           (set-machine-pc! machine (+ current-pc pc-offset)))]

        [else
         (trace-state machine)
         (error-interrupt 2 "invalid opcode" opcode)]))))
