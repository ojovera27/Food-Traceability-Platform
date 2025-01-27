;; Product Origin Management Contract

(define-map products
  { product-id: uint }
  {
    name: (string-ascii 50),
    producer: principal,
    origin: (string-ascii 100),
    production-date: uint,
    expiration-date: uint
  }
)

(define-data-var product-nonce uint u0)

(define-public (register-product
  (name (string-ascii 50))
  (origin (string-ascii 100))
  (production-date uint)
  (expiration-date uint))
  (let
    ((new-id (+ (var-get product-nonce) u1)))
    (map-set products
      { product-id: new-id }
      {
        name: name,
        producer: tx-sender,
        origin: origin,
        production-date: production-date,
        expiration-date: expiration-date
      }
    )
    (var-set product-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-product (product-id uint))
  (map-get? products { product-id: product-id })
)

(define-public (update-expiration-date (product-id uint) (new-expiration-date uint))
  (let
    ((product (unwrap! (map-get? products { product-id: product-id }) (err u404))))
    (asserts! (is-eq tx-sender (get producer product)) (err u403))
    (map-set products
      { product-id: product-id }
      (merge product { expiration-date: new-expiration-date })
    )
    (ok true)
  )
)

