import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';

export const DomainFilter = () => {
  const { selectedDomains, setSelectedDomains, allDomains, domainsLoading } =
    useFiltersContext();

  return (
    <Autocomplete
      multiple
      inputLabel="Domains"
      options={allDomains.map((domain) => ({
        key: domain.id,
        value: domain.value,
      }))}
      value={(selectedDomains ?? []).map((d) => d.value)}
      onChange={(e, value) => {
        const selectedValues = (value as string[]).filter(Boolean);

        const selected = allDomains.filter((domain) =>
          selectedValues.includes(domain.value)
        );

        setSelectedDomains(selected);
      }}
      loading={domainsLoading}
      disableClearable={false}
    />
  );
};
