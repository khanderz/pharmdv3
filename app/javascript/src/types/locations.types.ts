import { useState, useEffect } from "react";
import { Adjudicated } from "./adjudication.types";
import { useLocations } from "@hooks";

const [locations, setLocations] = useState<
  {
    id: number;
    name: string;
    location_type: string;
    code: string;
    parent_id: number;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { locations: allLocaitons } = useLocations();

useEffect(() => {
  if (allLocaitons) {
    setLocations(allLocaitons);
  }
}, [allLocaitons]);

export type Locations = (typeof locations)[number];

export interface Location extends Adjudicated {
  id: number;
  name: Locations["name"];
  location_type: Locations["location_type"];
  code: Locations["code"];
  parent_id: Locations["parent_id"];
}
