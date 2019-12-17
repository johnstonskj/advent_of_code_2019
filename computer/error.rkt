#lang racket/base

(provide error-reset error-code core-error exec-error)

;; ----------------------------------------------------------------------------

(define ERR 0)

;; ----------------------------------------------------------------------------

(define (error-code) ERR)

(define (error-reset)
  (set! ERR 0))

(define (core-error code msg val)
  (set! ERR code)
  (error 'CORE (format "code: ~a, message: ~a, source: ~a" code msg val)))

(define (exec-error code msg val)
  (set! ERR code)
  (error 'EXEC (format "code: ~a, message: ~a, source: ~a" code msg val)))
