#lang racket/base

(require adventofcode/computer/load adventofcode/computer/exec adventofcode/computer/gpio rackunit)

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 5, Part 1 *****"
 (program-load "../data/intcode-2.txt")
 (execute #:trace #t)

 (check-eq? (pin-value) 6731945))