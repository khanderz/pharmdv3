import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { AutocompleteOption } from '@components/atoms/Autocomplete';

export const CompanyFilter = () => {
  const { selectedCompanies, setSelectedCompanies, uniqueCompanies } =
    useFiltersContext();

  return (
    <Autocomplete
      multiple
      id={'company-autocomplete'}
      inputLabel="Companies"
      options={uniqueCompanies.map((company) => ({
        key: company.id,
        value: company.company_name,
      }))}
      value={(selectedCompanies ?? []).map((c) => {
        const company = uniqueCompanies.find((company) => company.id === c.id);

        return {
          key: company?.id ?? '',
          value: company?.company_name ?? '',
        };
      })}
      onChange={(e, value) => {
        const selectedValues = (value as AutocompleteOption[]).filter(Boolean);
        const selected = uniqueCompanies.filter((company) =>
          selectedValues.some((el) => el.value === company.company_name)
        );
        setSelectedCompanies(selected);
      }}
      loading={false}
    />
  );
};
