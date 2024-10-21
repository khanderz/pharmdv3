import { Adjudication } from "./adjudication.types";

export interface City {
    city_id: number;
    city_name: string;

    error_details: Adjudication['error_details'];
    reference_id: Adjudication['adjudicatable_id'];
    resolved: Adjudication['resolved'];
}

export interface State {
    state_id: number;
    state_code: string;
    state_name: string;
}

export interface Country {
    country_id: number;
    country_code: string;
    country_name: string;

    error_details: Adjudication['error_details'];
    reference_id: Adjudication['adjudicatable_id'];
    resolved: Adjudication['resolved'];
}