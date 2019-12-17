#lang racket/base

(require
  "error.rkt"
  racket/vector)

(provide core-ref core-set! core-init core-dump)

;; ----------------------------------------------------------------------------

(define *core-size* 1024)

(define CORE (make-vector *core-size* 0))

;; ----------------------------------------------------------------------------

(define (core-ref addr)
  (when (or (< addr 0) (>= addr *core-size*))
    (exec-error 1 "invalid core access addr" addr))
  (vector-ref CORE addr))

(define (core-set! addr v)
  (when (or (< addr 0) (>= addr *core-size*))
    (error 1 "invalid core access addr" addr))
  (vector-set! CORE addr v))

(define (core-init v)
  (for ([addr (in-range (vector-length v))])
    (core-set! addr (vector-ref v addr))))

(define (core-dump)
  (displayln CORE))
