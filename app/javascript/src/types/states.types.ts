import { useState, useEffect } from "react";
import { Adjudicated } from "./adjudication.types";
import { useStates } from "@javascript/hooks";
import { Country } from "./location.types";

const [states, setStates] = useState<
  {
    id: number;
    state_code: string;
    state_name: string;
    country_code: Country["country_code"];
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { states: allStates } = useStates();

useEffect(() => {
  if (allStates) {
    setStates(allStates);
  }
}, [allStates]);

export type States = (typeof states)[number];

export interface State {
  id: number;
  state_code: States["state_code"];
  state_name: States["state_name"];
  country_code: States["country_code"];
}
