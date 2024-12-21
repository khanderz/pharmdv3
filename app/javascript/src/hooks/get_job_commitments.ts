import { useState, useEffect } from "react";
import { JobCommitment } from "@customtypes/job_post";

export const useJobCommitments = () => {
  const [jobCommitments, setJobCommitments] = useState<JobCommitment[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchJobCommitments = async () => {
      try {
        setLoading(true);
        setError(null);

        const response = await fetch("/job_commitments.json");
        if (!response.ok) {
          throw new Error(`Error fetching job commitments: ${response.status}`);
        }

        const data = await response.json();
        setJobCommitments(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchJobCommitments();
  }, []);

  return { jobCommitments, loading, error };
};
