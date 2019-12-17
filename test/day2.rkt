#lang racket/base

(require
  adventofcode/computer/load adventofcode/computer/core adventofcode/computer/exec
  racket/bool
  rackunit)

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 2, Part 1 *****"
 (program-load "../data/intcode.txt")
 (core-set! 1 12)
 (core-set! 2 2)

 (execute #:trace #t)
 (check-eq? (core-ref 0) 3058646))

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 2, Part 2 *****"

 (define (brute-force-search target)
   (for*/or ([noun (in-range 100)]
             [verb (in-range 100)])
     (program-load "../data/intcode.txt")
     (core-set! 1 noun)
     (core-set! 2 verb)
     (execute)
     (let ([result (core-ref 0)])
     (if (= result target)
         (vector result noun verb)
         #f))))

 (let ([values (brute-force-search 19690720)])
   (if (false? values)
       (displayln "Oh crap")
       (let ([result (+ (* 100 (vector-ref values 1)) (vector-ref values 2))])
         (check-eq? result 8976)))))
