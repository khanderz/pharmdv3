import { useState, useEffect } from 'react';
import { HealthcareDomain } from './healthcare_domain.types';
import { useCompanySpecialties } from '@javascript/hooks';

const [companySpecialties, setCompanySpecialties] = useState<
  { id: number; key: string; value: string }[]
>([]);

const { companySpecialties: allSpecialties } = useCompanySpecialties();

useEffect(() => {
  if (allSpecialties) {
    setCompanySpecialties(allSpecialties);
  }
}, [allSpecialties]);

export type CompanySpecialtyEnum = (typeof companySpecialties)[number]['value'];

export interface CompanySpecialty {
  id: number;
  key: HealthcareDomain['key'];
  value: CompanySpecialtyEnum;
}
