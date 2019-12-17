#lang racket/base

(require
  adventofcode/computer
  racket/bool
  rackunit)

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 2, Part 1 *****"
 (let ([machine (make-machine)])
 (program-load machine "../data/intcode.txt")
 (core-set! machine 1 12)
 (core-set! machine 2 2)

 (execute machine #:trace #t)
 (check-eq? (core-ref machine 0) 3058646)))

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 2, Part 2 *****"

 (define (brute-force-search machine target)
   (for*/or ([noun (in-range 100)]
             [verb (in-range 100)])
     (program-load machine "../data/intcode.txt")
     (core-set! machine 1 noun)
     (core-set! machine 2 verb)
     (execute machine)
     (let ([result (core-ref machine 0)])
     (if (= result target)
         (vector result noun verb)
         #f))))

 (let ([values (brute-force-search (make-machine) 19690720)])
   (if (false? values)
       (displayln "Oh crap")
       (let ([result (+ (* 100 (vector-ref values 1)) (vector-ref values 2))])
         (check-eq? result 8976)))))
