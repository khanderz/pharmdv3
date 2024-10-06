// create_table "job_posts", force: :cascade do |t|
// t.bigint "companies_id", null: false
// t.string "job_title"
// t.text "job_description"
// t.string "job_url"
// t.string "job_location"
// t.string "job_dept"
// t.datetime "job_posted"
// t.datetime "job_updated"
// t.boolean "job_active"
// t.bigint "job_internal_id"
// t.bigint "job_url_id"
// t.string "job_internal_id_string"
// t.integer "job_salary_min"
// t.integer "job_salary_max"
// t.string "job_salary_range"
// t.string "job_country"
// t.string "job_setting"
// t.text "job_additional"
// t.string "job_commitment"
// t.string "job_team"
// t.string "job_allLocations"
// t.text "job_responsibilities"
// t.text "job_qualifications"
// t.text "job_applyUrl"
// t.datetime "created_at", null: false
// t.datetime "updated_at", null: false
// t.index ["companies_id"], name: "index_job_posts_on_companies_id"
// t.index ["job_url"], name: "index_job_posts_on_job_url", unique: true

import { Company } from "./company.types";



export interface JobPost {
    id: number;
    companies_id: Company['id'];
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