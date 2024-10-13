
export interface Company {
    id: number;
    company_name: string;
    operating_status: boolean;
    company_type: string; // enum?
    company_type_value: string;
    company_ats_type: string; // enum?
    company_size: string;
    last_funding_type: string;
    linkedin_url: string;
    is_public: boolean;
    year_founded: number;
    company_city: string;
    company_state: string;
    company_country: string;
    acquired_by: string;
    ats_id: string;
    company_description: string;
    created_at: Date;
    updated_at: Date;
    company_specialties: CompanySpecialty[];
}

export interface CompanySpecialty {
    key: string; // enum
    value: string; // enum
    company_type_id: number;
    created_at: Date;
    updated_at: Date;
}