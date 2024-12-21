import { useState, useEffect } from "react";
import { States } from "@customtypes/location.types";

export const useStates = () => {
  const [states, setStates] = useState<States[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchStates = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/states.json");
        if (!response.ok) {
          throw new Error(`Error fetching states: ${response.status}`);
        }

        const data = await response.json();
        setStates(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchStates();
  }, []);

  return { states, loading, error };
};
