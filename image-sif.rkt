#lang racket

(require racket/file)

(provide read-image image-width image-height image-checksum image-render image-display)

;; ----------------------------------------------------------------------------

(struct image
  (width
   height
   layers
   checksum))

;; ----------------------------------------------------------------------------

(define (read-image file-name width height)
  (let ([raw (string-trim (file->string file-name))]
        [layer-length (* width height)])
    (let ([layers (for/list ([start (in-range 0 (string-length raw) layer-length)])
                    (string->list (substring raw start (+ start layer-length))))])
      (image 
       width
       height
       layers
       (checksum layers)))))

(define (occurs layer char)
  (length (filter (λ (c) (char=? c char)) layer)))

(define (checksum layers)
  (let ([lowest-zeros
         (car
          (sort
           (map
            (λ (l) (list (occurs l #\0) (occurs l #\1) (occurs l #\2)))
            layers)
           <
           #:key car))])
    (* (cadr lowest-zeros) (caddr lowest-zeros))))

(define (image-render image)
  (let* ([stacked (apply map list (image-layers image))]
         [width (image-width image)]
         [rendered
          (list->string
           (for/list ([pixel stacked])
             (findf (lambda (p) (not (char=? p #\2))) pixel)))])
    (for/list ([start (in-range 0 (string-length rendered) width)])
      (string-replace
       (string-replace
        (substring rendered start (+ start width))
        "0" " ")
       "1" "*"))))

(define (image-display image)
  (let ([rendered (image-render image)])
  (for ([line rendered])
    (displayln line))))


