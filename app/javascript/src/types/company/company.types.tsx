import { Adjudicated } from '../adjudication.types';
import { City, State, Country } from '../location.types';
import { AtsType } from './ats_type.types';
import { CompanySize } from './company_size.types';
import { CompanySpecialty } from './company_specialty.types';
import { FundingType } from './funding_type.types';
import { HealthcareDomain } from './healthcare_domain.types';

export interface Company extends Adjudicated {
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
  city?: City;
  state?: State;
  country: Country;

  ats_id: string;
  ats_type: AtsType;

  company_specialties: CompanySpecialty[];
  company_domains: CompanyDomain[];
  created_at: Date;
  updated_at: Date;
}

export interface CompanyDomain {
  id: number;
  company_id: Company['id'];
  healthcare_domain: HealthcareDomain;
  healthcare_domain_id: number;
}
