import { useState, useEffect } from 'react';
import { FundingType } from '@customtypes/funding_types';

export const useFundingTypes = () => {
  const [fundingTypes, setFundingTypes] = useState<FundingType[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchFundingTypes = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/funding_types.json');
        if (!response.ok) {
          throw new Error(`Error fetching funding types: ${response.status}`);
        }

        const data = await response.json();
        setFundingTypes(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
      } finally {
        setLoading(false);
      }
    };

    fetchFundingTypes();
  }, []);

  return { fundingTypes, loading, error };
};
