import { useState, useEffect } from 'react';
import { JobPost } from '@customtypes/job_post';

export const useJobPosts = (domainId: number | null) => {

    const [jobPosts, setJobPosts] = useState<JobPost[]>([]);
    const [filteredJobPosts, setFilteredJobPosts] = useState<JobPost[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchJobPosts = async () => {
            try {
                setLoading(true);
                let url = '/job_posts.json';

                if (domainId) {
                    url += `?domain_id=${domainId}`;
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
                setError(err instanceof Error ? err.message : 'An unknown error occurred');
            } finally {
                setLoading(false);
            }
        };

        fetchJobPosts();
    }, [domainId]);

    return { jobPosts, filteredJobPosts, setFilteredJobPosts, loading, error };
};
