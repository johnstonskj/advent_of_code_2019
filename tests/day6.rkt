#lang racket/base

(require adventofcode/image-sif rackunit)

;; ----------------------------------------------------------------------------

(define msg (read-image "../data/encoded-image.txt" 25 6))

(test-case
 "***** Day 6, Part 1 *****"
 (let ([checksum (image-checksum msg)])
   (displayln checksum)
   (check-eq? checksum 2684)))

(test-case
 "***** Day 6, Part 2 *****"
 (image-display msg))