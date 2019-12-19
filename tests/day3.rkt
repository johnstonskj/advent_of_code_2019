#lang racket/base

(require adventofcode/wiring racket/list rackunit)

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 3, Part 1 *****"
 (let* ([wires (load-wires "../data/crossed-wires.txt")]
        [origin '(0 . 0)]
        [crossings (wires->crossings wires origin)]
        [distances (crossing-distances crossings origin)]
        [shortest (first distances)])
   (displayln
    (format
     "shortest distance is ~a to the point at x: ~a, y: ~a"
     (car shortest)
     (car (cdr shortest))
     (cdr (cdr shortest))))
   (check-eq? (car shortest) 266)))