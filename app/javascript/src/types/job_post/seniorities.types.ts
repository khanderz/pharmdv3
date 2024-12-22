import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useSeniorities } from "@hooks";

const [seniorities, setSeniorities] = useState<
  {
    id: number;
    job_seniority_code: string;
    job_seniority_label: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { seniorities: allSeniorities } = useSeniorities();

useEffect(() => {
  if (allSeniorities) {
    setSeniorities(allSeniorities);
  }
}, [allSeniorities]);

export type Seniorities = (typeof seniorities)[number];

export interface Seniority extends Adjudicated {
  id: Seniorities["id"];
  job_seniority_code: Seniorities["job_seniority_code"];
  job_seniority_label: Seniorities["job_seniority_label"];
}
