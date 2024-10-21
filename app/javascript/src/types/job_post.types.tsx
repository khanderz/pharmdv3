import { Company } from './company.types';
import {
    JobCommitment,
    JobSalaryInterval,
    JobSetting,
    JobSalaryCurrency
} from './job_post';
import { Adjudication } from './adjudication.types';
import { Country } from './location.types';
import { JobRole } from './job_role/job_role.types';

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
    job_locations: Record<string, string>[];
    job_responsibilities: string;
    job_qualifications: string[];
    job_applyUrl: string;
    job_additional: string;

    job_role: JobRole;
    job_salary_interval: JobSalaryInterval;
    job_salary_currency: JobSalaryCurrency;
    job_commitment: JobCommitment;
    job_setting: JobSetting;
    job_team: number; // Reference to a team
    job_dept: number; // Reference to department ID
    country: Country; // Country name or enum

    reference_id?: Adjudication['adjudicatable_id'];
    error_details?: Adjudication['error_details'];
    resolved: Adjudication['resolved'];

    created_at: Date;
    updated_at: Date;
}
