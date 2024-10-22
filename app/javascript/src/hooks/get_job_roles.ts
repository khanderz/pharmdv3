import { useState, useEffect } from 'react';
import { JobRole } from '@customtypes/job_role';

export const useJobRoles = () => {
  const [jobRoles, setJobRoles] = useState<JobRole[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchJobRoles = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/job_roles.json');
        if (!response.ok) {
          throw new Error(`Error fetching job roles: ${response.status}`);
        }

        const data = await response.json();
        setJobRoles(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
      } finally {
        setLoading(false);
      }
    };

    fetchJobRoles();
  }, []);

  return { jobRoles, loading, error };
};
