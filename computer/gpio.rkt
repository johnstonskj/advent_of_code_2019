#lang racket/base

(require racket/vector)

(provide pin-count pin-read pin-value pin-write)

;; ----------------------------------------------------------------------------

(struct io-pin (inp outp value))

(define (std-io-pin [value 'uninitialized])
  (io-pin (current-input-port) (current-output-port) value))

(define *pins*
  (vector
    (std-io-pin)))

;; ----------------------------------------------------------------------------

(define (pin-count)
  (vector-length *pins*))

(define (pin-read #:pin [pin 0])
  (let ([the-pin (vector-ref *pins* pin)])
    (let ([value (read (io-pin-inp the-pin))])
      (vector-set! *pins* pin (std-io-pin value))
      value)))

(define (pin-value #:pin [pin 0])
  (let ([the-pin (vector-ref *pins* pin)])
    (io-pin-value the-pin)))

(define (pin-write value #:pin [pin 0])
  (let ([the-pin (vector-ref *pins* pin)])
    (write value (io-pin-outp the-pin))
    (vector-set! *pins* pin (std-io-pin value))))
