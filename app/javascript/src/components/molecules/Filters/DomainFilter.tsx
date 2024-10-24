import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { HealthcareDomain } from '@customtypes/company';

export type DomainFilterProps = {
  domains: HealthcareDomain[];
  selectedDomains: HealthcareDomain[] | null;
  onDomainFilter: React.Dispatch<
    React.SetStateAction<HealthcareDomain[] | null>
  >;
  domainsLoading: boolean;
};

export const DomainFilter = ({
  domains,
  selectedDomains,
  onDomainFilter,
  domainsLoading,
}: DomainFilterProps) => {
  return (
    <Autocomplete
      multiple
      inputLabel="Domains"
      options={domains.map((domain) => ({
        key: domain.id,
        value: domain.value,
      }))}
      value={(selectedDomains ?? []).map((d) => d.value)}
      onChange={(e, value) => {
        const selectedValues = (value as HealthcareDomain['value'][]).filter(
          Boolean
        );

        const selected = domains.filter((domain) =>
          selectedValues.includes(domain.value)
        );

        onDomainFilter(selected);
      }}
      loading={domainsLoading}
      disableClearable={false}
    />
  );
};
