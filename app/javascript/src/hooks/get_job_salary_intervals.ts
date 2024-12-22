import { useState, useEffect } from "react";
import { SalaryInterval } from "@customtypes/job_post";

export const useJobSalaryIntervals = () => {
  const [jobSalaryIntervals, setJobSalaryIntervals] = useState<
    SalaryInterval[]
  >([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchJobSalaryIntervals = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/job_salary_intervals.json");
        if (!response.ok) {
          throw new Error(
            `Error fetching job salary intervals: ${response.status}`,
          );
        }

        const data = await response.json();
        setJobSalaryIntervals(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchJobSalaryIntervals();
  }, []);

  return { jobSalaryIntervals, loading, error };
};
