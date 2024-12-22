import { useState, useEffect } from "react";
import { Skill } from "@customtypes/job_post";

export const useSkills = () => {
  const [skills, setSkills] = useState<Skill[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchSkills = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/skills.json");
        if (!response.ok) {
          throw new Error(`Error fetching skills: ${response.status}`);
        }

        const data = await response.json();
        setSkills(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchSkills();
  }, []);

  return { skills, loading, error };
};
