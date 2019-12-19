#lang info
;;
;; Advent of Code 2019
;;
(define collection "adventofcode")
(define version "0.1")
(define pkg-desc "Solutions for https://adventofcode.com/2019")
(define pkg-authors '(johnstonskj))
(define pkg-license "LICENSE")
(define pkg-readme "README.md")

(define deps '(
  "base"
  "rackunit-lib"
  "racket-index"))
(define build-deps '(
  "scribble-lib"
  "scribble-math"
  "racket-doc"
  "sandbox-lib"))

