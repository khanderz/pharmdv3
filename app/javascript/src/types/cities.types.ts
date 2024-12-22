import { useState, useEffect } from "react";
import { Adjudicated } from "./adjudication.types";
import { useCities } from "@hooks";

const [cities, setCities] = useState<
  {
    id: number;
    city_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { cities: allCities } = useCities();

useEffect(() => {
  if (allCities) {
    setCities(allCities);
  }
}, [allCities]);

export type Cities = (typeof cities)[number];

export interface City extends Adjudicated {
  id: number;
  city_name: Cities["city_name"];
}
