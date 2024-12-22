import { useState, useEffect } from "react";
import { Currency } from "@customtypes/job_post";

export const useJobSalaryCurrencies = () => {
  const [jobSalaryCurrencies, setJobSalaryCurrencies] = useState<Currency[]>(
    [],
  );
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchJobSalaryCurrencies = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/job_salary_currencies.json");
        if (!response.ok) {
          throw new Error(
            `Error fetching job salary currencies: ${response.status}`,
          );
        }

        const data = await response.json();
        setJobSalaryCurrencies(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchJobSalaryCurrencies();
  }, []);

  return { jobSalaryCurrencies, loading, error };
};
