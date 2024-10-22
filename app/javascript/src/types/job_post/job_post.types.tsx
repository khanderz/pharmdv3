import {
  JobCommitment,
  JobSalaryInterval,
  JobSetting,
  JobSalaryCurrency,
} from '.';
import { Adjudicated } from '../adjudication.types';
import { Country } from '../location.types';
import { Department, JobRole, Team } from '../job_role';
import { Company } from '../company/company.types';

export interface JobPost extends Adjudicated {
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

  job_role_id: JobRole['id'];
  job_salary_interval: JobSalaryInterval;
  job_salary_currency: JobSalaryCurrency;
  job_commitment: JobCommitment;
  job_setting: JobSetting;
  team_id: Team['id'];
  department_id: Department['id'];
  country: Country;

  created_at: Date;
  updated_at: Date;
}
