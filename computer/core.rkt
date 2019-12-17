#lang racket/base

(require
  "error.rkt"
  racket/vector)

(provide make-core core-ref core-set! core-copy-from core-dump)

;; ----------------------------------------------------------------------------

(define (make-core core-size)
  (make-vector core-size 0))

(define (core-size core)
  (vector-length core))

(define (core-ref core addr)
  (when (or (< addr 0) (>= addr (core-size core)))
    (error-interrupt 1 "invalid core access addr" addr))
  (vector-ref core addr))

(define (core-set! core addr v)
  (when (or (< addr 0) (>= addr (core-size core)))
    (error-interrupt 1 "invalid core access addr" addr))
  (vector-set! core addr v))

(define (core-copy-from core v)
  (for ([addr (in-range (vector-length v))])
    (core-set! core addr (vector-ref v addr))))

(define (core-dump core)
  (displayln core))
