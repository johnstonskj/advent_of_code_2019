#lang racket/base

(require
  "core.rkt" "exec.rkt"
  racket/bool racket/file racket/string racket/vector)

(provide program-load)

;; ----------------------------------------------------------------------------

(define (program-load file-name)
  (reset)
  (core-init
   (for/vector ([s (string-split (file->string file-name) ",")])
     (let ([n (string->number s)])
       (if (number? n) n 0)))))
