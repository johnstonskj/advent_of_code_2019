#lang racket/base

(require adventofcode/wiring rackunit)

;; ----------------------------------------------------------------------------


(test-case
 "***** Day 3, Part 1 *****"
 (define test-wires
   (decode-wire "R75,D30,R83,U83,L12,D49,R71,U7,L72"))
 (define trace (trace-wire test-wires '(0 . 0)))
 (displayln trace))