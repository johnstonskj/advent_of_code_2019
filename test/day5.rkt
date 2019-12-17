#lang racket/base

(require adventofcode/computer/load adventofcode/computer/exec rackunit)

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 5, Part 1 *****"
 (program-load "../data/intcode-2.txt")

 ; 6731945
 
 (displayln (execute #:trace #t)))