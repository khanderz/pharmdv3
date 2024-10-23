import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { HealthcareDomain } from '@customtypes/company';

export type DomainFilterProps = {
  domains: HealthcareDomain[];
  selectedDomains: HealthcareDomain[] | null;
  onDomainFilter: (domains: HealthcareDomain[] | null) => void;
};

export const DomainFilter = ({
  domains,
  selectedDomains,
  onDomainFilter,
}: DomainFilterProps) => {
  return (
    <Select
      multiple
      inputLabel="Domains"
      value={(selectedDomains ?? []).map(
        (d) => d.key as HealthcareDomain['key']
      )}
      onChange={(e) => {
        const selectedValues = e.target.value as HealthcareDomain['key'][];
        const selected = domains.filter((domain) =>
          selectedValues.includes(domain.key)
        );
        onDomainFilter(selected);
      }}
      renderValue={(selected) =>
        (selected as HealthcareDomain['value'][])
          .map((value) => domains.find((d) => d.key === value)?.value)
          .join(', ')
      }
    >
      {domains.map((domain) => (
        <MenuItem key={domain.key} value={domain.key}>
          {domain.value}
        </MenuItem>
      ))}
    </Select>
  );
};
