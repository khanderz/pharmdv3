import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useSkills } from "@hooks";

const [skills, setSkills] = useState<
  {
    id: number;
    skill_code: string;
    skill_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { skills: allSkills } = useSkills();

useEffect(() => {
  if (allSkills) {
    setSkills(allSkills);
  }
}, [allSkills]);

export type Skills = (typeof skills)[number];

export interface Skill extends Adjudicated {
  id: Skills["id"];
  skill_code: Skills["skill_code"];
  skill_name: Skills["skill_name"];
}
