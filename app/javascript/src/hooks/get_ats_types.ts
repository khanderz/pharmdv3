import { useState, useEffect } from 'react';
import { AtsType } from '@customtypes/ats_type';

export const useAtsTypes = () => {
  const [atsTypes, setAtsTypes] = useState<AtsType[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchAtsTypes = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/api/ats_types');
        if (!response.ok) {
          throw new Error(`Error fetching ATS types: ${response.status}`);
        }

        const data = await response.json();
        setAtsTypes(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
      } finally {
        setLoading(false);
      }
    };

    fetchAtsTypes();
  }, []);

  return { atsTypes, loading, error };
};
