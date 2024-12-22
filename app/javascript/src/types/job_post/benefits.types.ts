import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useBenefits } from "@hooks";

const [benefits, setBenefits] = useState<
  {
    id: number;
    benefit_name: string;
    benefit_category: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { benefits: allBenefits } = useBenefits();

useEffect(() => {
  if (allBenefits) {
    setBenefits(allBenefits);
  }
}, [allBenefits]);

export type Benefits = (typeof benefits)[number];

export interface Benefit extends Adjudicated {
  id: Benefits["id"];
  benefit_name: Benefits["benefit_name"];
  benefit_category: Benefits["benefit_category"];
}
