#lang racket/base

(provide error-interrupt)

(define (error-interrupt machine code msg val)
  ((dynamic-require "_machine.rkt" 'set-machine-error-code!) machine code)
  (error 'EXEC (format "code: ~a, message: ~a, source: ~a" code msg val)))