import {
    CompanySize,
    AtsType,
    HealthcareDomain,
    FundingType,
    CompanySpecialty
} from "./company/index";
import { Adjudication } from "./adjudication.types"

export interface Company {
    id: number;
    company_name: string;
    operating_status: boolean;
    company_description: string;
    linkedin_url: string;
    is_public: boolean;
    year_founded: number;
    acquired_by: string;

    company_size?: CompanySize;
    funding_type?: FundingType;
    city?: City; // Reference to the city model
    state?: State; // Reference to the state model
    country?: Country; // Reference to the country model

    ats_id: string;
    ats_type: AtsType;

    error_details: Adjudication['error_details'];
    reference_id: Adjudication['adjudicatable_id'];
    resolved: Adjudication['resolved'];

    company_specialties: CompanySpecialty[];
    healthcare_domains: HealthcareDomain[];
    created_at: Date;
    updated_at: Date;
}

export interface City {
    id: number;
    city_name: string;
    created_at: Date;
    updated_at: Date;
}

export interface State {
    id: number;
    state_code: string;
    state_name: string;
    created_at: Date;
    updated_at: Date;
}

export interface Country {
    id: number;
    country_code: string;
    country_name: string;
    created_at: Date;
    updated_at: Date;
}
