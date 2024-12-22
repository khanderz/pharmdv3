import { useState, useEffect } from "react";
import { HealthcareDomain } from "./healthcare_domain.types";
import { useCompanySpecialties } from "hooks";

const [companySpecialties, setCompanySpecialties] = useState<
  { id: number; key: string; value: string }[]
>([]);

const { companySpecialties: allSpecialties } = useCompanySpecialties();

useEffect(() => {
  if (allSpecialties) {
    setCompanySpecialties(allSpecialties);
  }
}, [allSpecialties]);

export type CompanySpecialties = (typeof companySpecialties)[number];

export interface CompanySpecialty {
  id: number;
  key: HealthcareDomain["key"];
  value: CompanySpecialties["value"];
}
