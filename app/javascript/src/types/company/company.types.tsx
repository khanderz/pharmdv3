import { Adjudication } from "../adjudication.types";
import { City, State, Country } from "../location.types";
import { AtsType } from "./ats_type.types";
import { CompanySize } from "./company_size.types";
import { CompanySpecialty } from "./company_specialty.types";
import { FundingType } from "./funding_type.types";
import { HealthcareDomain } from "./healthcare_domain.types";

export interface Company {
    company_id: number;
    company_name: string;
    operating_status: boolean;
    company_description: string;
    linkedin_url: string;
    is_public: boolean;
    year_founded: number;
    acquired_by: string;

    company_size?: CompanySize;
    funding_type?: FundingType;
    city?: City;
    state?: State;
    country: Country;

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