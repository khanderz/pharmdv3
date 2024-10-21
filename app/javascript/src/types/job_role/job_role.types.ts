import { Adjudication } from "../adjudication.types";

export interface JobRole {
    job_role_id: number;
    job_role_name: string;

    error_details: Adjudication['error_details'];
    reference_id: Adjudication['adjudicatable_id'];
    resolved: Adjudication['resolved'];
}