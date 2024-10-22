import { useState, useEffect } from 'react';
import { HealthcareDomain } from '@customtypes/company';

export const useHealthcareDomains = () => {
    const [allDomains, setAllDomains] = useState<HealthcareDomain[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchDomains = async () => {
            try {
                setLoading(true); // Start loading before the request
                setError(null); // Reset error before fetching

                const response = await fetch('/healthcare_domains.json');
                if (!response.ok) {
                    throw new Error(`Error fetching healthcare domains: ${response.status}`);
                }

                const data = await response.json();
                setAllDomains(data); // Set the fetched domains
            } catch (err) {
                setError(err instanceof Error ? err.message : 'An unknown error occurred');
            } finally {
                setLoading(false); // End loading once the request is complete
            }
        };

        fetchDomains();
    }, []);

    return { allDomains, loading, error };
};
