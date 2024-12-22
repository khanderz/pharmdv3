import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useExperiences } from "@hooks";

const [experiences, setExperiences] = useState<
  {
    id: number;
    experience_code: string;
    experience_name: string;
    min_years: number;
    max_years: number;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { experiences: allExperiences } = useExperiences();

useEffect(() => {
  if (allExperiences) {
    setExperiences(allExperiences);
  }
}, [allExperiences]);

export type Experiences = (typeof experiences)[number];

export interface Experience extends Adjudicated {
  id: Experiences["id"];
  experience_code: Experiences["experience_code"];
  experience_name: Experiences["experience_name"];
  min_years: Experiences["min_years"];
  max_years: Experiences["max_years"];
}
