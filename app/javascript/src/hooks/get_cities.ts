import { useState, useEffect } from "react";
import { Cities } from "@customtypes/cities.types";

export const useCities = () => {
  const [cities, setCities] = useState<Cities[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchCities = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/cities.json");
        if (!response.ok) {
          throw new Error(`Error fetching cities: ${response.status}`);
        }

        const data = await response.json();
        setCities(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchCities();
  }, []);

  return { cities, loading, error };
};
