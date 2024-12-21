import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useJobRoles } from "@javascript/hooks";

const [jobRoles, setJobRoles] = useState<
  {
    id: number;
    role_name: string;
  }[]
>([]);

const { jobRoles: allJobRoles } = useJobRoles();

useEffect(() => {
  if (allJobRoles) {
    setJobRoles(allJobRoles);
  }
}, [allJobRoles]);

export type JobRoles = (typeof jobRoles)[number];

export interface JobRole extends Adjudicated {
  id: number;
  role_name: JobRoles["role_name"];
}
