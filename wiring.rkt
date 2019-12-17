#lang racket/base

(require racket/file racket/string)

(provide load-wires)

;; ----------------------------------------------------------------------------

(define (load-wires file-name)
  (map decode-wire (file->lines file-name)))

;; ----------------------------------------------------------------------------

(define (decode-point point-string)
  (let ([dir (string-ref point-string 0)]
        [dist (string->number (substring point-string 1))])
    (cons (cond
            [(char=? dir #\L) 'left]
            [(char=? dir #\R) 'right]
            [(char=? dir #\U) 'up]
            [(char=? dir #\D) 'down])
          dist)))

(define (decode-wire wire-line)
  (map decode-point (string-split wire-line ",")))

(define (trace-wire wire origin)
  (list->set
   (flatten
    (let next-point ([point origin] [dir wire]))
      
    (for/list ([p (append wire])
      