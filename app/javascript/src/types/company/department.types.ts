export const Department = {
    BUSINESS_DEVELOPMENT: 'Business Development',
    CLINICAL_TEAM: 'Clinical Team',
    CUSTOMER_SUPPORT: 'Customer Support',
    DATA_SCIENCE: 'Data Science',
    DESIGN: 'Design',
    ENGINEERING: 'Engineering',
    INTERNSHIP: 'Internship',
    IT: 'IT',
    FINANCE: 'Finance',
    HUMAN_RESOURCES: 'Human Resources',
    LEGAL: 'Legal',
    MARKETING: 'Marketing',
    OPERATIONS: 'Operations',
    PRODUCT_MANAGEMENT: 'Product Management',
    SALES: 'Sales',
} as const;

export type DepartmentKey = keyof typeof Department;
export type DepartmentValue = typeof Department[DepartmentKey];
