import { useState, useEffect } from 'react';
import { CompanySize } from '@customtypes/company';

export const useCompanySizes = () => {
  const [companySizes, setCompanySizes] = useState<CompanySize[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchCompanySizes = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/company_sizes.json');
        if (!response.ok) {
          throw new Error(`Error fetching company sizes: ${response.status}`);
        }

        const data = await response.json();
        setCompanySizes(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
      } finally {
        setLoading(false);
      }
    };

    fetchCompanySizes();
  }, []);

  return { companySizes, loading, error };
};
