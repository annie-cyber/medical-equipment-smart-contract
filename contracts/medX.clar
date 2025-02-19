;; MedicalEquipment Smart Contract
;; Enables secure tracking of medical equipment lifecycle and compliance

(define-trait equipment-tracking-trait
  (
    (register-equipment (uint uint) (response bool uint))
    (update-equipment-state (uint uint) (response bool uint))
    (get-equipment-timeline (uint) (response (list 10 {state: uint, recorded-at: uint}) uint))
    (add-compliance-record (uint uint principal) (response bool uint))
    (verify-compliance (uint uint) (response bool uint))
  )
)

;; Define equipment state constants
(define-constant EQUIP_STATE_PRODUCTION u1)
(define-constant EQUIP_STATE_QA u2)
(define-constant EQUIP_STATE_ACTIVE u3)
(define-constant EQUIP_STATE_SERVICE u4)

;; Define compliance type constants
(define-constant COMPLIANCE_FDA u1)
(define-constant COMPLIANCE_EU u2)
(define-constant COMPLIANCE_ISO13485 u3)
(define-constant COMPLIANCE_IEC60601 u4)

;; Error constants
(define-constant ERR_NOT_AUTHORIZED (err u1))
(define-constant ERR_INVALID_EQUIPMENT (err u2))
(define-constant ERR_STATE_UPDATE_FAILED (err u3))
(define-constant ERR_INVALID_STATE (err u4))
(define-constant ERR_INVALID_COMPLIANCE (err u5))
(define-constant ERR_COMPLIANCE_DUPLICATE (err u6))

;; Contract administrator
(define-data-var contract-admin principal tx-sender)

;; Event sequence counter
(define-data-var event-sequence uint u0)

;; Equipment tracking map
(define-map equipment-registry 
  {equipment-id: uint} 
  {
    manufacturer: principal,
    current-state: uint,
    timeline: (list 10 {state: uint, recorded-at: uint})
  }
)

;; Compliance tracking map
(define-map equipment-compliance
  {equipment-id: uint, compliance-type: uint}
  {
    authority: principal,
    recorded-at: uint,
    active: bool
  }
)

;; Authorized regulatory authorities
(define-map regulatory-authorities
  {entity: principal, compliance-type: uint}
  {authorized: bool}
)

;; Get current sequence and increment
(define-private (get-sequence-number)
  (begin
    (var-set event-sequence (+ (var-get event-sequence) u1))
    (var-get event-sequence)
  )
)

;; Only contract admin can perform certain actions
(define-read-only (is-contract-admin (caller principal))
  (is-eq caller (var-get contract-admin))
)

;; Validate equipment state
(define-private (is-valid-state (state uint))
  (or 
    (is-eq state EQUIP_STATE_PRODUCTION)
    (is-eq state EQUIP_STATE_QA)
    (is-eq state EQUIP_STATE_ACTIVE)
    (is-eq state EQUIP_STATE_SERVICE)
  )
)

;; Validate compliance type
(define-private (is-valid-compliance-type (compliance-type uint))
  (or
    (is-eq compliance-type COMPLIANCE_FDA)
    (is-eq compliance-type COMPLIANCE_EU)
    (is-eq compliance-type COMPLIANCE_ISO13485)
    (is-eq compliance-type COMPLIANCE_IEC60601)
  )
)

;; Validate equipment ID
(define-private (is-valid-equipment-id (equipment-id uint))
  (and (> equipment-id u0) (<= equipment-id u999999))
)

;; Check if sender is authorized authority
(define-private (is-regulatory-authority (entity principal) (compliance-type uint))
  (default-to 
    false
    (get authorized (map-get? regulatory-authorities {entity: entity, compliance-type: compliance-type}))
  )
)

;; Register new equipment
(define-public (register-equipment (equipment-id uint) (initial-state uint))
  (begin
    (asserts! (is-valid-equipment-id equipment-id) ERR_INVALID_EQUIPMENT)
    (asserts! (is-valid-state initial-state) ERR_INVALID_STATE)
    (asserts! (or (is-contract-admin tx-sender) (is-eq initial-state EQUIP_STATE_PRODUCTION)) ERR_NOT_AUTHORIZED)
    
    (map-set equipment-registry 
      {equipment-id: equipment-id}
      {
        manufacturer: tx-sender,
        current-state: initial-state,
        timeline: (list {state: initial-state, recorded-at: (get-sequence-number)})
      }
    )
    (ok true)
  )
)

