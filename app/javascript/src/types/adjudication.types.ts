export interface Adjudication {
    id: number;
    adjudicatable_type: string;
    adjudicatable_id: number;
    error_details: string;
    resolved: boolean;
    created_at: Date;
    updated_at: Date;
}