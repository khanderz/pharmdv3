import React from 'react';
import { Company } from '@customtypes/company';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';

export type CompanyFilterProps = {
  companies: Company[];
  selectedCompanies: Company[] | null;
  onCompanyFilter: (companies: Company[] | null) => void;
};

export const CompanyFilter = ({
  companies,
  selectedCompanies,
  onCompanyFilter,
}: CompanyFilterProps) => {
  return (
    <Select
      multiple
      inputLabel="Companies"
      value={(selectedCompanies ?? []).map((c) => c.id as Company['id'])}
      onChange={(e) => {
        const selectedValues = e.target.value as Company['id'][];
        const selected = companies.filter((company) =>
          selectedValues.includes(company.id)
        );
        onCompanyFilter(selected);
      }}
      renderValue={(selected) =>
        (selected as Company['id'][])
          .map((value) => companies.find((c) => c.id === value)?.company_name)
          .join(', ')
      }
    >
      {companies.map((company) => (
        <MenuItem key={company.id} value={company.id}>
          {company.company_name}
        </MenuItem>
      ))}
    </Select>
  );
};
