import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { AutocompleteOption } from '@components/atoms/Autocomplete';

export const DomainFilter = () => {
  const { selectedDomains, setSelectedDomains, allDomains, domainsLoading } =
    useFiltersContext();

  const options = allDomains.map((domain) => ({
    key: domain.id,
    value: domain.value,
  }));

  const selectedOptions = (selectedDomains ?? []).map((selected) => {
    const domain = options.find((option) => option.value === selected.value);

    return {
      key: domain?.key ?? '',
      value: domain?.value ?? '',
    };
  });

  return (
    <Autocomplete
      multiple
      inputLabel="Domains"
      options={options}
      value={selectedOptions}
      onChange={(e, value) => {
        const selectedValues = (value as AutocompleteOption[]).filter(Boolean);

        const selected = allDomains.filter((domain) =>
          selectedValues.some((el) => el.value === domain.value)
        );

        setSelectedDomains(selected);
      }}
      loading={domainsLoading}
    />
  );
};
