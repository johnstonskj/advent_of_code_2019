#lang racket/base

(require adventofcode/passwords rackunit)

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 4, Part 1 *****"

 (let ([result (length (password-matches 271973 785961 elven-match?))])
   (displayln result)
   (check-eq? result 925)))

;; ----------------------------------------------------------------------------

(test-case
 "***** Day 4, Part 2 *****"

 (elven-match-limited? 1234566)
 (elven-match-limited? 1234466)
 (elven-match-limited? 1244466)
 (elven-match-limited? 1244467)
 (elven-match-limited? 1244666))