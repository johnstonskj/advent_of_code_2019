#lang racket/base

(require adventofcode/computer rackunit)

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 5, Part 1 *****"
 (let ([machine (make-machine)])
   (program-load machine "../data/intcode-2.txt")
   (execute machine #:trace #t)

   (check-eq? (pin-value machine #:pin 0) 6731945)))