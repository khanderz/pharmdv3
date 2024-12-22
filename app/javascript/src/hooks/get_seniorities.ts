import { useState, useEffect } from "react";
import { Seniority } from "@customtypes/job_post";

export const useSeniorities = () => {
  const [seniorities, setSeniorities] = useState<Seniority[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchSeniorities = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/seniorities.json");
        if (!response.ok) {
          throw new Error(`Error fetching seniorities: ${response.status}`);
        }

        const data = await response.json();
        setSeniorities(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchSeniorities();
  }, []);

  return { seniorities, loading, error };
};
