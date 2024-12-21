import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { getCurrencies } from "@javascript/hooks";

const [currencies, setCurrencies] = useState<
  {
    key: number;
    label: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { currencies: allCurrencies } = getCurrencies();

useEffect(() => {
  if (allCurrencies) {
    setCurrencies(allCurrencies);
  }
}, [allCurrencies]);

export type JobSalaryCurrencies = (typeof currencies)[number];

export interface JobSalaryCurrency extends Adjudicated {
  key: JobSalaryCurrencies["key"];
  label: JobSalaryCurrencies["label"];
}
