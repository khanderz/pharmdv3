import { useState, useEffect } from 'react';
import { Adjudicated } from './adjudication.types';

const [countries, setCountries] = useState<
  {
    id: number;
    country_name: string;
    error_details: Adjudicated['error_details'];
    reference_id: Adjudicated['reference_id'];
    resolved: Adjudicated['resolved'];
  }[]
>([]);
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

export type Countries = (typeof countries)[number];
export type States = (typeof states)[number];
export type Cities = (typeof cities)[number];

export interface City extends Adjudicated {
  id: number;
  city_name: Cities;
}

export interface State {
  id: number;
  state_name: States;
}

export interface Country extends Adjudicated {
  id: number;
  country_name: Countries;
}
