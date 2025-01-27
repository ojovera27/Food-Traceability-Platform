;; Transportation and Storage Monitoring Contract

(define-map transport-records
  { record-id: uint }
  {
    product-id: uint,
    from-location: (string-ascii 100),
    to-location: (string-ascii 100),
    departure-time: uint,
    arrival-time: uint,
    temperature-log: (list 100 int),
    humidity-log: (list 100 uint)
  }
)

(define-data-var record-nonce uint u0)

(define-public (create-transport-record
  (product-id uint)
  (from-location (string-ascii 100))
  (to-location (string-ascii 100))
  (departure-time uint))
  (let
    ((new-id (+ (var-get record-nonce) u1)))
    (map-set transport-records
      { record-id: new-id }
      {
        product-id: product-id,
        from-location: from-location,
        to-location: to-location,
        departure-time: departure-time,
        arrival-time: u0,
        temperature-log: (list),
        humidity-log: (list)
      }
    )
    (var-set record-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-transport-record
  (record-id uint)
  (arrival-time uint)
  (temperature-log (list 100 int))
  (humidity-log (list 100 uint)))
  (let
    ((record (unwrap! (map-get? transport-records { record-id: record-id }) (err u404))))
    (map-set transport-records
      { record-id: record-id }
      (merge record
        {
          arrival-time: arrival-time,
          temperature-log: temperature-log,
          humidity-log: humidity-log
        }
      )
    )
    (ok true)
  )
)

(define-read-only (get-transport-record (record-id uint))
  (map-get? transport-records { record-id: record-id })
)

