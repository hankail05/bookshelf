#lang sicp
(define (boats-and-daughters)
  (let ((moore-boat 'lorna) (downing-boat 'melissa) (hall-boat 'rosalind) (barnacle-boat 'gabrielle) (parker-boat 'mary))
    (let ((moore (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
      (require (eq? moore parker-boat))
      (let ((barnacle (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
        (require (eq? barnacle downing-boat))
        (let ((downing (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
          (require (not (eq? downing downing-boat)))
          (require (not (eq? downing moore)))
          (require (not (eq? downing barnacle)))
          (let ((hall (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
            (require (not (eq? hall hall-boat)))
            (require (not (eq? hall moore)))
            (require (not (eq? hall barnacle)))
            (let ((parker (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
              (require (not (eq? parker parker-boat)))
              (require (not (eq? parker moore)))
              (require (not (eq? parker barnacle)))
              (require (not (eq? parker 'gabrielle)))
              (require (distinct? (list downing hall parker)))
              (require (cond ((eq? downing 'gabrielle) (eq? parker 'melissa))
                             ((eq? hall 'gabrielle) (eq? parker 'rosalind))))
              (list (list 'moore moore)
                    (list 'downing downing)
                    (list 'hall hall)
                    (list 'barnacle barnacle)
                    (list 'parker parker)))))))))

; ((moore mary) (downing lorna) (hall gabrielle) (barnacle melissa) (parker rosalind)) -> Downing is Lorna's father.


; No information of mary's surname:

(define (boats-and-daughters)
  (let ((moore-boat 'lorna) (downing-boat 'melissa) (hall-boat 'rosalind) (barnacle-boat 'gabrielle) (parker-boat 'mary))
    (let ((barnacle (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
      (require (eq? barnacle downing-boat))
      (let ((downing (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
        (require (not (eq? downing downing-boat)))
        (require (not (eq? downing barnacle)))
        (let ((hall (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
          (require (not (eq? hall hall-boat)))
          (require (not (eq? hall barnacle)))
          (let ((parker (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
            (require (not (eq? parker parker-boat)))
            (require (not (eq? parker barnacle)))
            (require (not (eq? parker 'gabrielle)))
            (let ((moore (amb 'lorna 'melissa 'rosalind 'gabrielle 'mary)))
              (require (not (eq? moore moore-boat)))
              (require (not (eq? moore barnacle)))
              (require (distinct? (list moore downing hall parker)))
              (require (cond ((eq? downing 'gabrielle) (eq? parker downing-boat))
                             ((eq? hall 'gabrielle) (eq? parker hall-boat))
                             ((eq? moore 'gabrielle) (eq? parker moore-boat))))
              (list (list 'moore moore)
                    (list 'downing downing)
                    (list 'hall hall)
                    (list 'barnacle barnacle)
                    (list 'parker parker)))))))))

; ((moore mary) (downing lorna) (hall gabrielle) (barnacle melissa) (parker rosalind))
; ((moore gabrielle) (downing rosalind) (hall mary) (barnacle melissa) (parker lorna))