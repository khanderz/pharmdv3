import React from 'react';
import { Autocomplete } from '@components/atoms';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { AutocompleteOption } from '@components/atoms/Autocomplete';
import { CompanySizeEnum } from '@customtypes/company/company_size.types';

export const CompanySizeFilter = () => {
  const { selectedCompanySize, setSelectedCompanySize } = useFiltersContext();

  const options: AutocompleteOption[] = [
    { key: 1, value: CompanySizeEnum.SMALL_1_10 },
    { key: 2, value: CompanySizeEnum.SMALL_11_50 },
    { key: 3, value: CompanySizeEnum.MEDIUM_51_200 },
    { key: 4, value: CompanySizeEnum.MEDIUM_201_500 },
    { key: 5, value: CompanySizeEnum.LARGE_501_1000 },
    { key: 6, value: CompanySizeEnum.LARGE_1001_5000 },
    { key: 7, value: CompanySizeEnum.ENTERPRISE_5001_10000 },
    { key: 8, value: CompanySizeEnum.ENTERPRISE_10001_PLUS },
  ];

  const selectedOption =
    options.find((option) => option.value === selectedCompanySize) || null;

  return (
    <Autocomplete
      inputLabel="Company Size"
      options={options}
      value={selectedOption}
      onChange={(event, newValue) => {
        const selectedValue = (newValue as AutocompleteOption)?.value || '';
        setSelectedCompanySize(selectedValue as string);
      }}
      id="company-size-autocomplete"
    />
  );
};
