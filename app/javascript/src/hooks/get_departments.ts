import { useState, useEffect } from 'react';
import { Department } from '@customtypes/job_role';

export const useDepartments = () => {
  const [departments, setDepartments] = useState<Department[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchDepartments = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/departments.json');
        if (!response.ok) {
          throw new Error(`Error fetching departments: ${response.status}`);
        }

        const data = await response.json();
        setDepartments(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
      } finally {
        setLoading(false);
      }
    };

    fetchDepartments();
  }, []);

  return { departments, loading, error };
};
