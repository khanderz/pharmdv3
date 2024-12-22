import { useState, useEffect } from "react";
import { Adjudicated } from "./adjudication.types";
import { useCountries } from "@javascript/hooks";

const [countries, setCountries] = useState<
  {
    id: number;
    country_code: string;
    country_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { countries: allCountries } = useCountries();

useEffect(() => {
  if (allCountries) {
    setCountries(allCountries);
  }
}, [allCountries]);

export type Countries = (typeof countries)[number];

export interface Country extends Adjudicated {
  id: number;
  country_code: Countries["country_code"];
  country_name: Countries["country_name"];
}
