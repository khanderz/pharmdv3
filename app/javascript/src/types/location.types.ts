import { useState, useEffect } from "react";
import { Adjudicated } from "./adjudication.types";
import { useCities, useStates, useCountries } from "@javascript/hooks";

const [countries, setCountries] = useState<
  {
    id: number;
    country_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);
const [states, setStates] = useState<
  {
    id: number;
    state_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);
const [cities, setCities] = useState<
  {
    id: number;
    city_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { countries: allCountries } = useCountries();
const { states: allStates } = useStates();
const { cities: allCities } = useCities();

useEffect(() => {
  if (allCountries) {
    setCountries(allCountries);
  }
  if (allStates) {
    setStates(allStates);
  }
  if (allCities) {
    setCities(allCities);
  }
}, [allCountries, allStates, allCities]);

export type Countries = (typeof countries)[number];
export type States = (typeof states)[number];
export type Cities = (typeof cities)[number];

export interface City extends Adjudicated {
  id: number;
  city_name: Cities["city_name"];
}

export interface State {
  id: number;
  state_name: States["state_name"];
}

export interface Country extends Adjudicated {
  id: number;
  country_name: Countries["country_name"];
}
