import { Company } from './company.types';
import {
    JobCommitment,
    JobSalaryInterval,
    JobSetting,
    JobSalaryCurrency
} from './job_post';
import { Adjudication } from './adjudication.types';

export interface JobPost {
    id: number;
    company: Company;
    job_title: string;
    job_description: string;
    job_url: string;
    job_posted: Date;
    job_updated: Date;
    job_active: boolean;
    job_internal_id: number;
    job_url_id: number;
    job_internal_id_string: string;
    job_salary_min: number;
    job_salary_max: number;
    job_salary_interval_id: JobSalaryInterval;
    job_salary_currency_id: JobSalaryCurrency;
    job_commitment_id: JobCommitment;
    job_setting_id: JobSetting;
    job_team_id: number; // Reference to a team
    job_dept_id: number; // Reference to department ID
    job_locations: Record<string, string>[];
    job_responsibilities: string;
    job_qualifications: string[]; // Array of qualifications
    job_applyUrl: string;
    job_additional: string;
    country_id: number; // Reference to a country ID
    country: string; // Country name or enum
    reference_id?: Adjudication['adjudicatable_id'];
    error_details?: Adjudication['error_details'];
    resolved: Adjudication['resolved'];
    created_at: Date;
    updated_at: Date;
}
