import { useState, useEffect } from 'react';
import { CompanySpecialty } from '@customtypes/company';

export const useCompanySpecialties = () => {
  const [companySpecialties, setCompanySpecialties] = useState<
    CompanySpecialty[]
  >([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchCompanySpecialties = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/company_specialties.json');
        if (!response.ok) {
          throw new Error(
            `Error fetching company specialties: ${response.status}`
          );
        }

        const data = await response.json();
        setCompanySpecialties(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
      } finally {
        setLoading(false);
      }
    };

    fetchCompanySpecialties();
  }, []);

  return { companySpecialties, loading, error };
};
