import { useState, useEffect } from "react";
import { HealthcareDomain } from "@customtypes/company";

export const useHealthcareDomains = () => {
  const [allDomains, setAllDomains] = useState<HealthcareDomain[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchDomains = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/healthcare_domains.json");
        if (!response.ok) {
          throw new Error(
            `Error fetching healthcare domains: ${response.status}`,
          );
        }

        const data = await response.json();
        setAllDomains(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchDomains();
  }, []);

  return { allDomains, loading, error };
};
