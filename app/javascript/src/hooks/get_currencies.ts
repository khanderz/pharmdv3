import { JobSalaryCurrency } from '@customtypes/job_post';
import { useState, useEffect } from 'react';

export const getCurrencies = () => {
    const [currencies, setCurrencies] = useState<JobSalaryCurrency[]>([]);
    const [loading, setLoading] = useState<boolean>(true);
    const [error, setError] = useState<string | null>(null);

    useEffect(() => {
        const fetchCurrencies = async () => {
            try {
                setLoading(true);
                setError(null);

                const response = await fetch('/job_salary_currencies.json');
                if (!response.ok) {
                    throw new Error(`Error fetching currencies: ${response.status}`);
                }

                const data = await response.json();
                setCurrencies(data);
            } catch (err) {
                setError(
                    err instanceof Error ? err.message : 'An unknown error occurred'
                );
            } finally {
                setLoading(false);
            }
        };

        fetchCurrencies();
    }, []);

    return { currencies, loading, error };
}