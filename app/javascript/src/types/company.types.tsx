// create_table "companies", force: :cascade do |t|
// t.string "company_name"
// t.boolean "operating_status"
// t.string "company_type"
// t.string "company_type_value"
// t.string "company_ats_type"
// t.string "company_size"
// t.string "last_funding_type"
// t.string "linkedin_url"
// t.boolean "is_public"
// t.integer "year_founded"
// t.string "company_city"
// t.string "company_state"
// t.string "company_country"
// t.string "acquired_by"
// t.string "ats_id"
// t.text "company_description"
// t.datetime "created_at", null: false
// t.datetime "updated_at", null: false
// t.index ["company_name"], name: "index_companies_on_company_name", unique: true
// t.index ["linkedin_url"], name: "index_companies_on_linkedin_url", unique: true
// end

export interface Company {
    id: number;
    company_name: string;
    operating_status: boolean;
    company_type: string; // enum?
    company_type_value: string;
    company_ats_type: string; // enum?
    company_size: string;
    last_funding_type: string;
    linkedin_url: string;
    is_public: boolean;
    year_founded: number;
    company_city: string;
    company_state: string;
    company_country: string;
    acquired_by: string;
    ats_id: string;
    company_description: string;
    created_at: Date;
    updated_at: Date;
    company_specialties: string;
}