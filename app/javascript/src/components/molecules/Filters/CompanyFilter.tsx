import React from 'react';
import { Company } from '@customtypes/company';
import { Autocomplete } from '@components/atoms/index';

export type CompanyFilterProps = {
  companies: Company[];
  selectedCompanies: Company[] | null;
  onCompanyFilter: React.Dispatch<React.SetStateAction<Company[] | null>>;
  // loading: boolean;
};

export const CompanyFilter = ({
  companies,
  selectedCompanies,
  onCompanyFilter,
  // loading,
}: CompanyFilterProps) => {
  return (
    <Autocomplete
      multiple
      inputLabel="Companies"
      options={companies.map((company) => ({
        key: company.id,
        value: company.company_name,
      }))}
      value={(selectedCompanies ?? []).map((c) => c.company_name)}
      onChange={(e, value) => {
        const selectedValues = (value as Company['company_name'][]).filter(
          Boolean
        ) as Company['company_name'][];
        const selected = companies.filter((company) =>
          selectedValues.includes(company.company_name)
        );
        onCompanyFilter(selected);
      }}
      loading={false}
      disableClearable={false}
    />
  );
};
