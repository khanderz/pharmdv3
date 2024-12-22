import { useState, useEffect } from "react";
import { Benefit } from "@customtypes/job_post";

export const useBenefits = () => {
  const [benefits, setBenefits] = useState<Benefit[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchBenefits = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/benefits.json");
        if (!response.ok) {
          throw new Error(`Error fetching benefits: ${response.status}`);
        }

        const data = await response.json();
        setBenefits(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchBenefits();
  }, []);

  return { benefits, loading, error };
};
