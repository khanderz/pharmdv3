import { useState, useEffect } from "react";
import { Adjudication } from "./adjudication.types";

const [countries, setCountries] = useState<string[]>([]);
const [states, setStates] = useState<string[]>([]);
const [cities, setCities] = useState<string[]>([]);

useEffect(() => {
    const fetchCountries = async () => {
        try {
            const response = await fetch('/countries.json');
            if (!response.ok) {
                throw new Error(`Error fetching countries: ${response.status}`);
            }
            const data = await response.json();
            setCountries(data);
        } catch (error) {
            console.error(error);
        }
    };

    const fetchStates = async () => {
        try {
            const response = await fetch('/states.json');
            if (!response.ok) {
                throw new Error(`Error fetching states: ${response.status}`);
            }
            const data = await response.json();
            setStates(data);
        } catch (error) {
            console.error(error);
        }
    };

    const fetchCities = async () => {
        try {
            const response = await fetch('/cities.json');
            if (!response.ok) {
                throw new Error(`Error fetching cities: ${response.status}`);
            }
            const data = await response.json();
            setCities(data);
        } catch (error) {
            console.error(error);
        }
    };

    fetchCountries();
    fetchStates();
    fetchCities();
}, []);


export type Countries = typeof countries[number];
export type States = typeof states[number];
export type Cities = typeof cities[number];

export interface City {
    city_id: number;
    city_name: Cities;

    error_details: Adjudication['error_details'];
    reference_id: Adjudication['adjudicatable_id'];
    resolved: Adjudication['resolved'];
}

export interface State {
    state_id: number;
    state_name: States;
}

export interface Country {
    country_id: number;
    country_name: Countries;

    error_details: Adjudication['error_details'];
    reference_id: Adjudication['adjudicatable_id'];
    resolved: Adjudication['resolved'];
}