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
      value={(selectedCompanies ?? []).map((c) => c.company_name)}
      onChange={(e) => {
        const selectedValues = e.target.value as Company['company_name'][];
        const selected = companies.filter((company) =>
          selectedValues.includes(company.company_name)
        );

        onCompanyFilter(selected);
      }}
      renderValue={(selected: Company[]) => {
        if (Array.isArray(selected)) {
          const selectedNames = selected.map((co) => {
            const company = companies.find((c) => c.id === co.id);
            return company?.company_name;
          });

          return selectedNames;
        } else {
          return <em>All Companies</em>;
        }
      }}
    >
      {companies.map((company) => (
        <MenuItem key={company.id} value={company.company_name}>
          {company.company_name}
        </MenuItem>
      ))}
    </Select>
  );
};
