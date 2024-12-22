import { useState, useEffect } from "react";
import { Credential } from "@customtypes/job_post";

export const useCredentials = () => {
  const [credentials, setCredentials] = useState<Credential[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchCredentials = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/credentials.json");
        if (!response.ok) {
          throw new Error(`Error fetching credentials: ${response.status}`);
        }

        const data = await response.json();
        setCredentials(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchCredentials();
  }, []);

  return { credentials, loading, error };
};
