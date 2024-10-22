import { useState, useEffect } from 'react';
import { Team } from '@customtypes/job_role';

export const useTeams = () => {
  const [teams, setTeams] = useState<Team[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchTeams = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch('/teams.json');
        if (!response.ok) {
          throw new Error(`Error fetching teams: ${response.status}`);
        }

        const data = await response.json();
        setTeams(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
      } finally {
        setLoading(false);
      }
    };

    fetchTeams();
  }, []);

  return { teams, loading, error };
};
