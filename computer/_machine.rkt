#lang racket

(require
  (prefix-in mem: "core.rkt")
  (prefix-in io: "gpio.rkt"))

(provide make-machine
         (except-out (struct-out machine) machine))

(struct machine
  (core
   pins
   [clock #:mutable]
   [pc #:mutable]
   [state #:mutable]
   [error-code #:mutable])
  #:transparent)

(define (make-machine #:core-size [core-size 1024] #:pin-count [pin-count 1])
  (machine (mem:make-core core-size) (io:make-pins pin-count) 0 0 'init 0))
