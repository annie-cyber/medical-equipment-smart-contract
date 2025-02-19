# Medical Equipment Tracking Smart Contract

## Overview
This smart contract implements a comprehensive tracking system for medical equipment lifecycle and compliance management. Built using Clarity smart contract language, it enables transparent and secure tracking of medical equipment from production through deployment and maintenance, while managing various compliance certifications.

## Features

### Equipment Lifecycle Management
- Register new medical equipment
- Track equipment state changes
- Maintain an auditable timeline of equipment states
- Support for multiple equipment states:
  - Production
  - Quality Assurance
  - Active/Deployed
  - Service/Maintenance

### Compliance Management
- Track multiple compliance certifications
  - FDA Approval
  - EU Certification
  - ISO 13485 Compliance
  - IEC 60601 Safety Standards
- Verify active certifications
- Manage regulatory authorities
- Maintain compliance history

### Security Features
- Role-based access control
- Authorized regulatory authorities
- Secure state transitions
- Validated equipment IDs
- Protected compliance records

## Smart Contract Functions

### Administrative Functions
```clarity
(define-public (register-equipment (equipment-id uint) (initial-state uint)))
(define-public (update-equipment-state (equipment-id uint) (new-state uint)))
(define-public (add-compliance-record (equipment-id uint) (compliance-type uint)))
```

### Read-Only Functions
```clarity
(define-read-only (verify-compliance (equipment-id uint) (compliance-type uint)))
(define-read-only (get-equipment-timeline (equipment-id uint)))
(define-read-only (get-equipment-state (equipment-id uint)))
(define-read-only (get-compliance-details (equipment-id uint) (compliance-type uint)))
```

## Equipment States
- `EQUIP_STATE_PRODUCTION (u1)`: Equipment is in production
- `EQUIP_STATE_QA (u2)`: Equipment is undergoing quality assurance
- `EQUIP_STATE_ACTIVE (u3)`: Equipment is actively deployed
- `EQUIP_STATE_SERVICE (u4)`: Equipment is under maintenance

## Compliance Types
- `COMPLIANCE_FDA (u1)`: FDA approval
- `COMPLIANCE_EU (u2)`: European Union certification
- `COMPLIANCE_ISO13485 (u3)`: ISO 13485 medical devices quality management
- `COMPLIANCE_IEC60601 (u4)`: IEC 60601 medical electrical equipment safety

## Error Codes
- `ERR_NOT_AUTHORIZED (u1)`: Unauthorized access attempt
- `ERR_INVALID_EQUIPMENT (u2)`: Invalid equipment ID
- `ERR_STATE_UPDATE_FAILED (u3)`: Failed to update equipment state
- `ERR_INVALID_STATE (u4)`: Invalid equipment state
- `ERR_INVALID_COMPLIANCE (u5)`: Invalid compliance type
- `ERR_COMPLIANCE_DUPLICATE (u6)`: Duplicate compliance record

## Usage Examples

### Registering New Equipment
```clarity
;; Register new equipment in production state
(contract-call? .medical-equipment register-equipment u1 EQUIP_STATE_PRODUCTION)
```

### Updating Equipment State
```clarity
;; Update equipment state to active
(contract-call? .medical-equipment update-equipment-state u1 EQUIP_STATE_ACTIVE)
```

### Adding Compliance Record
```clarity
;; Add FDA compliance record
(contract-call? .medical-equipment add-compliance-record u1 COMPLIANCE_FDA)
```

### Verifying Compliance
```clarity
;; Verify FDA compliance
(contract-call? .medical-equipment verify-compliance u1 COMPLIANCE_FDA)
```

## Security Considerations
1. Only authorized regulatory authorities can add compliance records
2. Equipment state updates require appropriate authorization
3. Compliance records cannot be duplicated
4. Equipment IDs are validated before any operation
5. State transitions are protected by role-based access control

## Data Storage
The contract uses three main data maps:
- `equipment-registry`: Stores equipment details and state history
- `equipment-compliance`: Tracks compliance certifications
- `regulatory-authorities`: Manages authorized regulatory bodies

## Implementation Notes
- Maximum timeline history: 10 entries per equipment
- Equipment IDs range: 1 to 999999
- All state changes are recorded with sequence numbers
- Compliance records are immutable once created

## Contributing
When contributing to this project, please ensure:
1. All new functions include appropriate error handling
2. Access control is properly implemented
3. Data validation is thorough
4. Timeline entries are properly managed
5. Test cases are included for new functionality
