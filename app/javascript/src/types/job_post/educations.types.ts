import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useEducations } from "@hooks";

const [educations, setEducations] = useState<
  {
    id: number;
    education_code: string;
    education_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { educations: allEducations } = useEducations();

useEffect(() => {
  if (allEducations) {
    setEducations(allEducations);
  }
}, [allEducations]);

export type Educations = (typeof educations)[number];

export interface Education extends Adjudicated {
  id: Educations["id"];
  education_code: Educations["education_code"];
  education_name: Educations["education_name"];
}
