import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useDepartments } from "@hooks";

const [departments, setDepartments] = useState<
  {
    id: number;
    dept_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { departments: allDepartments } = useDepartments();

useEffect(() => {
  if (allDepartments) {
    setDepartments(allDepartments);
  }
}, [allDepartments]);

export type Departments = (typeof departments)[number];

export interface Department extends Adjudicated {
  id: number;
  dept_name: Departments["dept_name"];
}
