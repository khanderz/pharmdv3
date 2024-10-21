export const HealthcareDomainEnum = {
    BEHAVIORAL_HEALTH: 'Behavioral Health',
    CARDIOLOGY: 'Cardiology',
    DENTAL: 'Dental',
    DERMATOLOGY: 'Dermatology',
    DIGITAL_HEALTH: 'Digital Health',
    EMERGENCY_MEDICINE: 'Emergency Medicine',
    GERIATRICS: 'Geriatrics',
    NEUROLOGY: 'Neurology',
    NURSING: 'Nursing',
    OBSTETRICS: 'Obstetrics',
    ONCOLOGY: 'Oncology',
    OPTOMETRY: 'Optometry',
    PATHOLOGY: 'Pathology',
    PEDIATRICS: 'Pediatrics',
    PHARMA: 'Pharmaceuticals',
    PHYSICAL_THERAPY: 'Physical Therapy',
    PODIATRY: 'Podiatry',
    PRIMARY_CARE: 'Primary Care',
    PSYCHIATRY: 'Psychiatry',
    PUBLIC_HEALTH: 'Public Health',
    RADIOLOGY: 'Radiology',
    RESEARCH: 'Research',
    RESPIRATORY: 'Respiratory',
    REHABILITATION: 'Rehabilitation',
    SPEECH_THERAPY: 'Speech-Language Pathology',
    SURGERY: 'Surgery',
} as const;

export interface HealthcareDomain {
    key: keyof typeof HealthcareDomainEnum;
    value: typeof HealthcareDomainEnum[keyof typeof HealthcareDomainEnum];
}
