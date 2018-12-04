#lang sicp
(define (cons x y)
  (define (set-x! v) (set! x v))
  (define (set-y! v) (set! y v))
  (define (dispatch m)
    (cond ((eq? m 'car) x)
          ((eq? m 'cdr) y)
          ((eq? m 'set-car!) set-x!)
          ((eq? m 'set-cdr!) set-y!)
          (else (error "Undefined operation -- CONS" m))))
  dispatch)
(define (car z) (z 'car))
(define (cdr z) (z 'cdr))
(define (set-car! z new-value)
  ((z 'set-car!) new-value)
  z)
(define (set-cdr! z new-value)
  ((z 'set-cdr!) new-value)
  z)

;           ┌────────────────────────────────────────────────────────────────────────────────────────────────┐
;           │cons:───────────────────────────────────────────────────────────────────────────┐               │
; global -> │car:────────────────────────────────────────────────────┐                       │               │
; env       │cdr:──────────────────────────────────┐                 │                       │               │
;           │set-car!:────────────┐                │                 │                       │               │
;           │set-cdr!:─┐          │                │                 │                       │               │
;           └──────────┼──────────┼────────────────┼─────────────────┼───────────────────────┼───────────────┘
;                      │  ∧       │  ∧             │  ∧             │  ∧                    │  ∧
;                      ∨  │       ∨  │             ∨  │             ∨  │                    ∨  │
;                      ◎◎─┘       ◎◎─┘            ◎◎─┘             ◎◎─┘                    ◎◎─┘
;                      ∨          ∨                ∨                ∨                       ∨
;              parameter:z     parameter:z        parameter:z     parameter:z       parameters:x,y
;              body:(z 'car)   body:(z 'cdr)      body: ((z ...)) body: ((z ...))   body:(define (...)
;                                                                                        dispatch)


(define x (cons 1 2))
;           ┌────────────────────────────────────────────────────────────────────────────────────────────────┐
;           │cons:...                                                                                        │
; global -> │car:...                                                                                         │
; env       │cdr:...                                                                                         │
;           │set-car!:...                                                                                    │
;           │set-cdr!:...                                                                                    │
;           │x:─────┐                                                                                        │
;           └───────┼────────────────────────────────────────────────────────────────────────────────────────┘
;                   │                                              ∧
;                   │                ┌─────────────────────────────────────────────────────────┐
;                   │                │x:1                                                      │
;                   │                │y:2                                                      │
;                   │                │set-x!:───────────────────────────────────────────────┐  │
;                   │          E1 -> │set-y!:───────────────────────────┐                   │  │
;                   │                │dispatch:─┐                       │                   │  │
;                   │                └──────────┼───────────────────────┼───────────────────┼──┘
;                   │                  ∧        │  ∧                    │   ∧              │  ∧
;                   │  ┌───────────────┘        ◎◎─┘                    ◎◎─┘               ◎◎─┘  
;                   ∨  │                        ∨                       ∨                  ∨
;                   ◎◎─┘                   parameter:m             parameter:v         parameter:v
;                   ∨                      body:(cons (...))       body:(set! ...)     body:(cond (...))
;              parameter:m
;              body:dispatch

(define z (cons x x))
;           ┌────────────────────────────────────────────────────────────────────────────────────────────────┐
;           │cons:...                                                                                        │
; global -> │car:...                                                                                         │
; env       │cdr:...                                                                                         │
;           │set-car!:...                                                                                    │
;           │set-cdr!:...                                                                                    │
;           │x:...                                                                                           │
;           │z:─────┐                                                                                        │
;           └───────┼────────────────────────────────────────────────────────────────────────────────────────┘
;                   │       ∧                                     ∧  
;                   │       E1       ┌─────────────────────────────────────────────────────────┐
;                   │       │        │x:x                                                      │
;                   │       │        │y:x                                                      │
;                   │       │        │set-x!:───────────────────────────────────────────────┐  │
;                   │       │  E2 -> │set-y!:───────────────────────────┐                   │  │
;                   │       │        │dispatch:─┐                       │                   │  │
;                   │       │        └──────────┼───────────────────────┼───────────────────┼──┘
;                   │       │          ∧        │  ∧                    │   ∧              │  ∧
;                   │  ┌───────────────┘        ◎◎─┘                    ◎◎─┘               ◎◎─┘  
;                   ∨  │    │                   ∨                       ∨                  ∨
;                   ◎◎─┘    └───────────>  parameter:m             parameter:v         parameter:v
;                   ∨                      body:(cons (...))       body:(set! ...)     body:(cond (...))
;              parameter:m
;              body:dispatch

(set-car! (car z) 17)
;           ┌────────────────────────────────────────────────────────────────────────────────────────────────┐
;           │cons:...                                                                                        │
; global -> │car:...                                                                                         │
; env       │cdr:...                                                                                         │
;           │set-car!:...                                                                                    │
;           │set-cdr!:...                                                                                    │
;           │x:...                                                                                           │
;           │z:...                                                                                           │
;           └────────────────────────────────────────────────────────────────────────────────────────────────┘
;                                              ∧                           ∧
;               ┌────────────────────────────> E1                          E2
;               │                              ∧                           ∧
;         ┌────────────┐                 ┌────────────┐               ┌────────────┐
;     E5─>│v:17        │             E4─>│m:'set-car! │           E3─>│z:z         │
;         └────────────┘                 │new-value:17│               └────────────┘
;           (set! x v)                   └────────────┘                  (z 'car)
;                                   ((x 'set-car!) new-value) z)                                

(car x)
;           ┌────────────────────────────────────────────────────────────────────────────────────────────────┐
;           │cons:...                                                                                        │
; global -> │car:...                                                                                         │
; env       │cdr:...                                                                                         │
;           │set-car!:...                                                                                    │
;           │set-cdr!:...                                                                                    │
;           │x:...                                                                                           │
;           │z:...                                                                                           │
;           └────────────────────────────────────────────────────────────────────────────────────────────────┘
;                                              ∧                           ∧
;               ┌────────────────────────────> E1 (x:17)                   E2
;               │                              ∧
;         ┌────────────┐                 ┌────────────┐
;     E6─>│x:x         │             E6─>│x:x         │
;         └────────────┘                 └────────────┘
;               x                           (x 'car)