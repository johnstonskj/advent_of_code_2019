#lang racket/base

(require adventofcode/fueling rackunit)

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 1, Part 1 *****"
 (let ([module-masses (load-module-masses "../data/rocket-modules.txt")])
   (displayln
    (total-fuel (map mass-to-fuel module-masses)))))

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 1, Part 2 *****"
 (let ([module-masses (load-module-masses "../data/rocket-modules.txt")])
   (displayln
    (total-fuel (map mass-to-fuel/complete module-masses)))))

