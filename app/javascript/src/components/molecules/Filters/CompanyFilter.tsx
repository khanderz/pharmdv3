import React from 'react';
import { Company } from '@customtypes/company';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';

export const CompanyFilter = () => {
  const { selectedCompanies, setSelectedCompanies, uniqueCompanies } =
    useFiltersContext();

  return (
    <Autocomplete
      multiple
      inputLabel="Companies"
      options={uniqueCompanies.map((company) => ({
        key: company.id,
        value: company.company_name,
      }))}
      value={(selectedCompanies ?? []).map((c) => c.company_name)}
      onChange={(e, value) => {
        const selectedValues = (value as Company['company_name'][]).filter(
          Boolean
        ) as Company['company_name'][];
        const selected = uniqueCompanies.filter((company) =>
          selectedValues.includes(company.company_name)
        );
        setSelectedCompanies(selected);
      }}
      loading={false}
      disableClearable={false}
    />
  );
};
