import React from 'react';
import { Select } from '@components/atoms/Select';
import { MenuItem } from '@mui/material';
import { HealthcareDomain } from '@customtypes/company';

export type DomainFilterProps = {
  domains: HealthcareDomain[];
  selectedDomain: HealthcareDomain | null;
  onDomainFilter: (domain: HealthcareDomain | null) => void;
};

export const DomainFilter = ({
  domains,
  selectedDomain,
  onDomainFilter,
}: DomainFilterProps) => {
  return (
    <Select
      inputLabel="Domains"
      value={selectedDomain?.key || ''}
      onChange={(e) => {
        const domain = domains.find((domain) => domain.key === e.target.value);
        onDomainFilter(domain || null);
      }}
    >
      {domains.map((domain) => (
        <MenuItem key={domain.key} value={domain.key}>
          {domain.value}
        </MenuItem>
      ))}
    </Select>
  );
};
