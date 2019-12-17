#lang racket/base

(require
  "core.rkt" "error.rkt" "trace.rkt"
  racket/bool racket/file racket/format racket/list racket/string racket/vector)

(provide reset execute)

;; ----------------------------------------------------------------------------

(define PC 0)

(define STATE 'init)

;; ----------------------------------------------------------------------------

(define (reset)
  (error-reset)
  (set! STATE 'init)
  (set! PC 0))

(define (execute #:start [start 0]
                 #:trace [enabled #f])
  (trace-enable enabled)
  (set! PC start)
  (set! STATE 'running)
  (do () ((not (symbol=? STATE 'running)))
    (execute-instruction)))

;; ----------------------------------------------------------------------------

(define (param-iref i)
  (core-ref (+ PC i)))

(define (param-ref modes i)
  (let* ([c (+ PC i)]
         [mode (if (>= (length modes) i)
                   (cond
                     [(= i 1) (first modes)]
                     [(= i 2) (second modes)]
                     [(= i 3) (third modes)]
                     [(= i 4) (fourth modes)]
                     [else (exec-error 3 "invalid opcode mode ref" i)])
                   0)]
         [immediate (core-ref c)])
    (cond
      [(= mode *opcode-mode-position*)
       (trace-param immediate #t)
       (core-ref immediate)]
      [(= mode *opcode-mode-immediate*)
       (trace-param immediate #f)
       immediate]
      [else (exec-error 3 "invalid opcode mode" mode)])))

(define *instructions*
  (hash
   1 (λ (modes)
       (trace-opcode "ADD")
       (let ([xv (param-ref modes 1)]
             [yv (param-ref modes 2)]
             [result (param-iref 3)])
         (trace-param result #t)
         (core-set! result (+ xv yv)))
       4)
   2 (λ (modes)
       (trace-opcode "MUL")
       (let ([xv (param-ref modes 1)]
             [yv (param-ref modes 2)]
             [result (param-iref 3)])
         (trace-param result #t)
         (core-set! result (* xv yv)))
       4)
   3 (λ (modes)
       (let ([result (param-iref 1)])
         (trace-opcode "INP")
         (trace-param result #t)
         (let ([input (read)])
           (unless (number? input)
             (exec-error 4 "invalid input" input))
           (core-set! result input)))
       2)
   4 (λ (modes)
       (let ([result (param-iref 1)])
         (trace-opcode "OUT")
         (trace-param result #t)
         (display (format "[[~a]]" (core-ref result))))
       2)
   5 (λ (modes)
       (trace-opcode "JIFT")
       (let ([test (param-ref modes 1)]
             [newpc (param-ref modes 2)])
         (cond
           [(not (= test 0))
            (set! PC newpc)
            0]
           [else 2])))
   6 (λ (modes)
       (trace-opcode "JIFF")
       (let ([test (param-ref modes 1)]
             [newpc (param-ref modes 2)])
         (cond
           [(= test 0)
            (set! PC newpc)
            0]
           [else 2])))
   7 (λ (modes)
       (trace-opcode "LT")
       (let ([left (param-ref modes 1)]
             [right (param-ref modes 2)]
             [result (param-iref 3)])
         (trace-param result #t)
         (cond
           [(< left right)
            (core-set! result 1)]
           [else (core-set! result 0)]))
       4)
   8 (λ (modes)
       (trace-opcode "EQ")
       (let ([left (param-ref modes 1)]
             [right (param-ref modes 2)]
             [result (param-iref 3)])
         (trace-param result #t)
         (cond
           [(= left right)
            (core-set! result 1)]
           [else (core-set! result 0)]))
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

(define (execute-instruction)
  (traceln)
  (let ([opcode (core-ref PC)])
    (let-values ([(opcode modes) (decode-opcode opcode)])
      (trace-state PC STATE (error-code))
      (cond
        [(= opcode *opcode-halt*)
         (trace-opcode "HALT")
         (set! STATE 'halted)]

        [(hash-has-key? *instructions* opcode)
         (let* ([instruction (hash-ref  *instructions* opcode)]
                [pc-offset (instruction modes)])
           (set! PC (+ PC pc-offset)))]

        [else
         (trace-state PC STATE 2)
         (core-dump)
         (exec-error 2 "invalid opcode" opcode)]))))
