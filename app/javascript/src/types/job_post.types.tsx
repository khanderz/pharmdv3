import { Company } from "./company.types";

export interface JobPost {
    id: number;
    companies_id: Company['id'];
    company: Company;
    job_title: string;
    job_description: string;
    job_url: string;
    job_location: string;
    job_dept: string;
    job_posted: Date;
    job_updated: Date;
    job_active: boolean;
    job_internal_id: number;
    job_url_id: number;
    job_internal_id_string: string;
    job_salary_min: number;
    job_salary_max: number;
    job_salary_range: string;
    job_country: string;
    job_setting: string;
    job_additional: string;
    job_commitment: string;
    job_team: string;
    job_allLocations: string;
    job_responsibilities: string;
    job_qualifications: string; // array?
    job_applyUrl: string;
    created_at: Date;
    updated_at: Date;
}