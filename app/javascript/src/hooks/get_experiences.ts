import { useState, useEffect } from "react";
import { Experience } from "@customtypes/job_post";

export const useExperiences = () => {
  const [experiences, setExperiences] = useState<Experience[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchExperiences = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/experiences.json");
        if (!response.ok) {
          throw new Error(`Error fetching experiences: ${response.status}`);
        }

        const data = await response.json();
        setExperiences(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchExperiences();
  }, []);

  return { experiences, loading, error };
};
