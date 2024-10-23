import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { HealthcareDomain } from '@customtypes/company';

export type DomainFilterProps = {
  domains: HealthcareDomain[];
  selectedDomains: HealthcareDomain[] | null;
  onDomainFilter: React.Dispatch<
    React.SetStateAction<HealthcareDomain[] | null>
  >;
  resetDomainFilter: () => void;
};

export const DomainFilter = ({
  domains,
  selectedDomains,
  onDomainFilter,
  resetDomainFilter,
}: DomainFilterProps) => {
  return (
    <Select
      multiple
      inputLabel="Domains"
      value={selectedDomains ? selectedDomains.map((d) => d.id) : []}
      onChange={(e) => {
        const selectedValues = e.target.value as number[];
        const selected = domains.filter((domain) =>
          selectedValues.includes(domain.id)
        );
        onDomainFilter(selected);
      }}
      renderValue={(selected) => {
        if ((selected as []).length === 0) {
          return <em>All Domains</em>;
        }

        const selectedNames = (selected as number[]).map((id) => {
          const domain = domains.find((domain) => domain.id === id);
          return domain?.value;
        });

        return selectedNames.join(', ');
      }}
      onReset={resetDomainFilter}
    >
      {domains.map((domain) => (
        <MenuItem key={domain.id} value={domain.id}>
          {domain.value}
        </MenuItem>
      ))}
    </Select>
  );
};
