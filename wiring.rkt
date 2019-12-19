#lang racket/base

(require racket/bool racket/file racket/list racket/set racket/string)

(provide load-wires wires->crossings crossing-distances)

;; ----------------------------------------------------------------------------

(define (load-wires file-name)
  (map decode-wire (file->lines file-name)))

(define (decode-wire wire-line)
  (map decode-point (string-split wire-line ",")))

(define (decode-point point-string)
  (let ([dir (string-ref point-string 0)]
        [dist (string->number (substring point-string 1))])
    (cons (cond
            [(char=? dir #\L) 'left]
            [(char=? dir #\R) 'right]
            [(char=? dir #\U) 'up]
            [(char=? dir #\D) 'down])
          dist)))

(define (wires->crossings wires origin)
  ;; unsatisfactorily imperitive :(
  (let* ([traces (map (λ (wire) (wire->trace wire origin)) wires)]
         [all-points (mutable-set)]
         [crossed-points (mutable-set)])
    (set-union! all-points (first traces))
    (for ([trace (rest traces)])
      (set-union! crossed-points (set-intersect trace all-points))
      (set-union! all-points trace))
    (set-remove! crossed-points origin)
    crossed-points))

(define (wire->trace wire origin)
  (list->set ; removes any self crossings
   (for/fold
    ([from origin]
     [trace '()]
     #:result trace)
    ([move wire])
     (let* ([segment-trace (trace-segment from (car move) (cdr move))]
            [next-from (last segment-trace)])
       (values next-from (append trace segment-trace))))))

(define (trace-segment start dir dist)
  (define (trace-segment/i start dx dy count)
    (for/list ([i (in-range (+ count 1))])
      (cons (+ (car start) (* dx i)) (+ (cdr start) (* dy i)))))
  (cond
    [(symbol=? dir 'left)  (trace-segment/i start -1  0 dist)]
    [(symbol=? dir 'right) (trace-segment/i start  1  0 dist)]
    [(symbol=? dir 'up)    (trace-segment/i start  0  1 dist)]
    [(symbol=? dir 'down)  (trace-segment/i start  0 -1 dist)]))

(define (manhattan-distance p1 p2)
  (+
   (abs (- (car p1) (car p2)))
   (abs (- (cdr p1) (cdr p2)))))

(define (crossing-distances crossings origin)
  (sort
   (map (λ (crossing)
          (cons
           (manhattan-distance origin crossing)
           crossing))
        (set->list crossings))
   #:key car <))
