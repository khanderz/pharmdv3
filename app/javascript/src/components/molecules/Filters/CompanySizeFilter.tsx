import React from 'react';
import { Autocomplete } from '@components/atoms';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { AutocompleteOption } from '@components/atoms/Autocomplete';
import { CompanySize } from '@customtypes/company';

export const CompanySizeFilter = () => {
  const { selectedCompanySize, setSelectedCompanySize, companySizesLoading, companySizes } = useFiltersContext();

  const options: AutocompleteOption[] = companySizes.map((size) => ({
    key: size.id,
    value: size.id, 
    label: size.size_range, 
  }));

  const selectedOptions = options.filter((option) =>
    selectedCompanySize.includes(option.value as CompanySize['id'])
  );

  return (
    <Autocomplete
      inputLabel="Company Size"
      options={options}
      value={selectedOptions}
      multiple
      onChange={(event, newValue) => {
        const selectedIds = (newValue as AutocompleteOption[]).map(
          (option) => option.value as CompanySize['id']
        );
        setSelectedCompanySize(selectedIds);
      }}
      id="company-size-autocomplete"
      loading={companySizesLoading}
      getOptionLabel={(option) => {
        return options.find((o) => o.value === option.value)?.label || ''
      }}
    />
  );
};
