import { useState, useEffect } from "react";
import { Countries } from "@customtypes/location.types";

export const useCountries = () => {
  const [countries, setCountries] = useState<Countries[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchCountries = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/countries.json");
        if (!response.ok) {
          throw new Error(`Error fetching countries: ${response.status}`);
        }

        const data = await response.json();
        setCountries(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchCountries();
  }, []);

  return { countries, loading, error };
};
