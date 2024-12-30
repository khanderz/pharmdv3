import { useState, useEffect } from "react";
import { Locations } from "@customtypes/locations.types";

export const useLocations = () => {
  const [locations, setLocations] = useState<Locations[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchLocations = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/locations.json");
        if (!response.ok) {
          throw new Error(`Error fetching locations: ${response.status}`);
        }

        const data = await response.json();
        setLocations(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchLocations();
  }, []);

  return { locations, loading, error };
};
