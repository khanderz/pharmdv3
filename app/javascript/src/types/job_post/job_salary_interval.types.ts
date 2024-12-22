import { useState, useEffect } from "react";
import { useJobSalaryIntervals } from "@hooks";

const [salaryIntervals, setSalaryIntervals] = useState<
  {
    id: number;
    interval: string;
  }[]
>([]);

const { salaryIntervals: allSalaryIntervals } = useJobSalaryIntervals();

useEffect(() => {
  if (allSalaryIntervals) {
    setSalaryIntervals(allSalaryIntervals);
  }
}, [allSalaryIntervals]);

export type SalaryIntervals = (typeof salaryIntervals)[number];

export interface SalaryInterval {
  id: SalaryIntervals["id"];
  interval: SalaryIntervals["interval"];
}
