import { useState, useEffect } from "react";
import { HealthcareDomain } from "./healthcare_domain.types";

const [companySpecialties, setCompanySpecialties] = useState<{ value: string; domain_key: string }[]>([]);

useEffect(() => {
    const fetchCompanySpecialties = async () => {
        try {
            const response = await fetch('/company_specialties.json');
            if (!response.ok) {
                throw new Error(`Error fetching company specialties: ${response.status}`);
            }
            const data = await response.json();
            setCompanySpecialties(data);
        } catch (error) {
            console.error(error);
        }
    };

    fetchCompanySpecialties();
}, []);

export type CompanySpecialtyEnum = typeof companySpecialties[number]['value'];

export interface CompanySpecialty {
    company_specialty_id: number;
    key: HealthcareDomain['key'];
    value: CompanySpecialtyEnum;
}
