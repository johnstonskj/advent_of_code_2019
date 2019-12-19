#lang racket/base
  
(require racket/file racket/list racket/set racket/string)

(provide load-orbits decode-orbit object-add total-orbits)

;; ----------------------------------------------------------------------------

(struct object
  (name
   [satelites #:mutable])
  #:transparent)

;; ----------------------------------------------------------------------------

(define all-objects (make-hash))

(define (load-orbits file-name)
  (map decode-orbit (file->lines file-name)))

(define (decode-orbit line)
  (let ([decoded (string-split line ")")])
    (object-add (second decoded) (first decoded))))

(define (object-add name around)
  (if (hash-has-key? all-objects around)
      (let ([around-object (hash-ref all-objects around)])
        (set-object-satelites! around-object (cons name (object-satelites around-object))))
      (hash-set! all-objects around (object around (list name))))
  (hash-set! all-objects name (object name '())))

(define (total-orbit-count starting-at depth)
  (let* ([starting-object (hash-ref all-objects starting-at)]
         [satelites (object-satelites starting-object)])
    (+ 
     (* depth (length satelites))
     (for/sum ([satelite satelites])
       (total-orbit-count satelite (+ depth 1))))))

(define (total-orbits starting-at)
  (total-orbit-count starting-at 1))



(decode-orbit "COM)B")
;(object-add "B" "COM")
(object-add "C" "B")
(object-add "D" "C")
(object-add "E" "D")
(object-add "F" "E")

(object-add "G" "B")
(object-add "H" "G")

(object-add "I" "D")

(object-add "J" "E")
(object-add "K" "J")
(object-add "L" "K")

(total-orbits "COM")

