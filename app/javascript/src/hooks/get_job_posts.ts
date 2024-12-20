import { useState, useEffect } from "react";
import { JobPost } from "@customtypes/job_post";
import { HealthcareDomain } from "@customtypes/company";

export const useJobPosts = (domainIds: HealthcareDomain["id"][] | null) => {
  const [jobPosts, setJobPosts] = useState<JobPost[]>([]);
  const [filteredJobPosts, setFilteredJobPosts] = useState<JobPost[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchJobPosts = async () => {
      try {
        setLoading(true);
        let url = "/job_posts.json";

        if (domainIds && domainIds.length > 0) {
          const domainParams = domainIds
            .map(id => `domain_ids[]=${id}`)
            .join("&");
          url += `?${domainParams}`;
        }

        const response = await fetch(url);
        if (!response.ok) {
          throw new Error(`Error fetching job posts: ${response.status}`);
        }

        const data = await response.json();
        setJobPosts(data);
        setFilteredJobPosts(data);
        setError(null);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchJobPosts();
  }, [domainIds]);

  return { jobPosts, filteredJobPosts, setFilteredJobPosts, loading, error };
};
