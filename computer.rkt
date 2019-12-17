#lang racket

(require
  (prefix-in private: "computer/_machine.rkt")
  (prefix-in mem: "computer/core.rkt")
  (prefix-in code: "computer/exec.rkt")
  (prefix-in io: "computer/gpio.rkt")) 

(provide make-machine machine-reset
         core-ref core-set!
         execute
         pin-read pin-value pin-write
         program-load)

;; ----------------------------------------------------------------------------

(define (make-machine #:core-size [core-size 1024] #:pin-count [pin-count 1])
  (private:make-machine #:core-size core-size #:pin-count pin-count))

(define (machine-reset machine)
  (private:set-machine-pc! machine 0)
  (private:set-machine-state! machine 'init)
  (private:set-machine-error-code! machine 0))

;; ----------------------------------------------------------------------------

(define (core-ref machine addr)
  (mem:core-ref (private:machine-core machine) addr))

(define (core-set! machine addr v)
  (mem:core-set! (private:machine-core machine) addr v))

;; ----------------------------------------------------------------------------

(define (execute machine
                 #:start [start 0]
                 #:trace [enabled #f])
  (code:execute machine #:start start #:trace enabled))

;; ----------------------------------------------------------------------------

(define (pin-read machine #:pin [pin 0])
  (io:pin-read (private:machine-pins machine) #:pin pin))

(define (pin-value machine #:pin [pin 0])
  (io:pin-value (private:machine-pins machine) #:pin pin))

(define (pin-write value machine #:pin [pin 0])
  (io:pin-write value (private:machine-pins machine) #:pin pin))

;; ----------------------------------------------------------------------------

(define (program-load machine file-name)
  (machine-reset machine)
  (mem:core-copy-from
   (private:machine-core machine)
   (for/vector ([s (string-split (file->string file-name) ",")])
     (let ([n (string->number s)])
       (if (number? n) n 0)))))