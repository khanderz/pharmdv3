import { JobCommitment, JobSalaryInterval, JobSalaryCurrency } from ".";
import { Adjudicated } from "../adjudication.types";
import { Department, JobRole, Team } from "../job_role";
import { Company } from "@customtypes/company";
import { Benefit } from "./benefits.types";
import { Location } from "../locations.types";
import { Credential } from "./credentials.types";
import { Education } from "./educations.types";
import { Experience } from "./experiences.types";
import { Seniority } from "./seniorities.types";
import { Skill } from "./skills.types";

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
  job_salary_single: number;
  job_responsibilities: string;
  job_qualifications: string[];
  job_applyUrl: string;
  job_additional: string;
  job_setting: string[];

  company_id: Company["id"];
  job_role_id: JobRole["id"];
  job_salary_interval_id: JobSalaryInterval;
  job_salary_currency_id: JobSalaryCurrency["id"];
  job_commitment_id: JobCommitment["id"];
  team_id: Team["id"];
  department_id: Department["id"];

  created_at: Date;
  updated_at: Date;
}

export interface JobPostBenefit {
  id: number;
  job_post_id: JobPost["id"];
  benefit_id: Benefit["id"];
}

export interface JobPostLocation {
  id: number;
  job_post_id: JobPost["id"];
  location_id: Location["id"];
}

export interface JobPostCredential {
  id: number;
  job_post_id: JobPost["id"];
  credential_id: Credential["id"];
}

export interface JobPostEducation {
  id: number;
  job_post_id: JobPost["id"];
  education_id: Education["id"];
}

export interface JobPostExperience {
  id: number;
  job_post_id: JobPost["id"];
  experience_id: Experience["id"];
}

export interface JobPostSeniority {
  id: number;
  job_post_id: JobPost["id"];
  seniority_id: Seniority["id"];
}

export interface JobPostSkill {
  id: number;
  job_post_id: JobPost["id"];
  skill_id: Skill["id"];
}
