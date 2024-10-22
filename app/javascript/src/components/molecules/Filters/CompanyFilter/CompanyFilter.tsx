import React from 'react';
import { Company } from '@customtypes/company';
import { Select } from '@components/atoms/Select';
import { MenuItem } from '@mui/material';

export type CompanyFilterProps = {
  companies: Company[];
  selectedCompany: Company | null;
  onCompanyFilter: (company: Company | null) => void;
};

export const CompanyFilter = ({
  companies,
  selectedCompany,
  onCompanyFilter,
}: CompanyFilterProps) => {
  return (
    <Select
      inputLabel="Company"
      value={selectedCompany?.id || ''}
      onChange={(e) => {
        const company = companies.find(
          (company) => company.id === Number(e.target.value)
        );
        onCompanyFilter(company || null);
      }}
    >
      {companies.map((company) => (
        <MenuItem key={company.id} value={company.id}>
          {company.company_name}
        </MenuItem>
      ))}
    </Select>
  );
};
