#lang racket/base

(require racket/file)

(provide load-module-masses total-fuel mass-to-fuel mass-to-fuel/complete)

;; ----------------------------------------------------------------------------

(define (total-fuel fuels)
  (foldl + 0 fuels))

(define (load-module-masses file-name)
  (map string->number (file->lines file-name)))

(define (mass-to-fuel mass)
  (- (floor (/ mass 3)) 2))

(define (mass-to-fuel/complete mass)
  (cond
    [(<= mass 6) 0]
    [else (let ([fuel (mass-to-fuel mass)])
            (+ fuel (mass-to-fuel/complete fuel)))]))
