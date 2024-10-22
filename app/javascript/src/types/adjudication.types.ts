export interface Adjudication extends Omit<Adjudicated, 'reference_id'> {
  id: number;
  adjudicatable_type: string;
  adjudicatable_id: number;
  created_at: Date;
  updated_at: Date;
}

export interface Adjudicated {
  reference_id: number;
  error_details: string;
  resolved: boolean;
}
