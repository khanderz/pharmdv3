import { useState, useEffect } from "react";

const [healthcareDomains, setHealthcareDomains] = useState<string[]>([]);

useEffect(() => {
    const fetchHealthcareDomains = async () => {
        try {
            const response = await fetch('/healthcare_domains.json');
            if (!response.ok) {
                throw new Error(`Error fetching healthcare domains: ${response.status}`);
            }
            const data = await response.json();
            setHealthcareDomains(data);
        } catch (error) {
            console.error(error);
        }
    };

    fetchHealthcareDomains();
}, []);

export type HealthcareDomainEnum = typeof healthcareDomains[number];

export interface HealthcareDomain {
    healthcare_domain_id: number;
    value: HealthcareDomainEnum;
}
