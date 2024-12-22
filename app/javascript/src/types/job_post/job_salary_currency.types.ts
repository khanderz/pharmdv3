import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useJobSalaryCurrencies } from "@hooks";

const [currencies, setCurrencies] = useState<
  {
    id: number;
    currency_code: string;
    currency_sign: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { currencies: allCurrencies } = useJobSalaryCurrencies();

useEffect(() => {
  if (allCurrencies) {
    setCurrencies(allCurrencies);
  }
}, [allCurrencies]);

export type Currencies = (typeof currencies)[number];

export interface Currency extends Adjudicated {
  id: Currencies["id"];
  currency_code: Currencies["currency_code"];
  currency_sign: Currencies["currency_sign"];
}
