import { useState, useEffect } from "react";
import { Education } from "@customtypes/job_post";

export const useEducations = () => {
  const [educations, setEducations] = useState<Education[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchEducations = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/educations.json");
        if (!response.ok) {
          throw new Error(`Error fetching educations: ${response.status}`);
        }

        const data = await response.json();
        setEducations(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchEducations();
  }, []);

  return { educations, loading, error };
};
