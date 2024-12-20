// src/hooks/useApiKey.ts

import { useState, useEffect } from "react";

export const useApiKey = () => {
  const [key, setKey] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchApiKey = async () => {
      try {
        const response = await fetch("/api/v1/fetch_data"); // Rails backend endpoint

        if (!response.ok) {
          throw new Error(`Error fetching API key: ${response.statusText}`);
        }

        const data = await response.json();
        const apiKey = data.api_key; // Assuming the API response contains the key as "api_key"
        setKey(apiKey);
      } catch (error) {
        setError("Failed to load API key.");
        console.error("Fetch API key error:", error);
      } finally {
        setLoading(false); // Stop loading once the fetch completes
      }
    };

    fetchApiKey();
  }, []); // Empty dependency array, so it runs only once when the component mounts

  return { key, loading, error };
};
