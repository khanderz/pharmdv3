import { Adjudicated } from "../adjudication.types";
import { AtsType } from "./ats_type.types";
import { CompanySize } from "./company_size.types";
import { CompanySpecialty } from "./company_specialty.types";
import { FundingType } from "./funding_type.types";
import { HealthcareDomain } from "./healthcare_domain.types";
import { CompanyType } from "./company_type.types";
import { Location } from "../locations.types";

export interface Company extends Adjudicated {
  id: number;
  company_name: string;
  operating_status: boolean;

  ats_type_id: AtsType["id"];
  company_size_id?: CompanySize["id"];
  funding_type_id?: FundingType["id"];

  linkedin_url?: string;
  company_url?: string;
  company_type_id?: CompanyType["id"];
  year_founded?: number;
  acquired_by?: string;

  ats_id: string;
  logo_url?: string;
  company_tagline?: string;
  is_completely_remote?: boolean;
  company_description: string;

  created_at: Date;
  updated_at: Date;
}

export interface CompanySpecialization {
  id: number;
  company_id: Company["id"];
  company_specialty_id: CompanySpecialty["id"];
  created_at: Date;
  updated_at: Date;
}

export interface CompanyDomain {
  id: number;
  company_id: Company["id"];
  healthcare_domain_id: HealthcareDomain["id"];
}

export interface CompanyLocation {
  id: number;
  company_id: Company["id"];
  location_id: Location["id"];
  created_at: Date;
  updated_at: Date;
}
