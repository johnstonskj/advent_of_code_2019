#lang racket/base

(require racket/list racket/set racket/stream)
  
(provide password-matches elven-match? elven-match-limited?)

;; ----------------------------------------------------------------------------

(define (password-matches start end match?)
  (stream->list (stream-filter match? (in-range start (+ end 1)))))

(define (number->vector num)
  (list->vector
   (number->list num)))

(define (number->list num)
  (map char->number (string->list (number->string num))))

(define (char->number c)
  (- (char->integer c) 48))
  
(define (elven-match? value)
  (let ([v-list (number->list value)])
    (for/fold ([one (first v-list)]
               [increasing #t]
               [duplicated #f]
               #:result (and increasing duplicated))
              ([two (rest v-list)])
      (values two (and increasing (<= one two)) (or duplicated (= one two))))))

(define (elven-match-limited? value)
  (let ([v-list (number->list value)])
    (for/fold ([zero -1]
               [one (first v-list)]
               [increasing #t]
               [duplicated #f]
               [limited #f]
               #:result (and increasing duplicated limited))
              ([two (rest v-list)])
      (values
       one
       two
       (and increasing (<= one two))
       (or duplicated (= one two))
       (or limited (= (set-count (set zero one two)) 2))))))
