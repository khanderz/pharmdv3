import { useState, useEffect } from 'react';
import { JobSetting } from '@customtypes/job_post';

export const useJobSettings = () => {
  const [jobSettings, setJobSettings] = useState<JobSetting[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchJobSettings = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/job_settings.json');
        if (!response.ok) {
          throw new Error(`Error fetching job settings: ${response.status}`);
        }

        const data = await response.json();
        setJobSettings(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
      } finally {
        setLoading(false);
      }
    };

    fetchJobSettings();
  }, []);

  return { jobSettings, loading, error };
};
