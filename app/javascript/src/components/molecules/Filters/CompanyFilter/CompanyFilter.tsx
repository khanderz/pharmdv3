import React from 'react';
import { Box, Typography, FormControl, Select, MenuItem } from '@mui/material';
import { Company } from '@customtypes/company';

export interface CompanyFilterProps {
  companies: Company[];
  selectedCompany: Company | null;
  onCompanyFilter: (company: Company | null) => void;
}

export const CompanyFilter = ({
  companies,
  selectedCompany,
  onCompanyFilter,
}: CompanyFilterProps) => {
  return (
    <Box sx={{ mt: 2 }}>
      <Typography variant="body1" sx={{ mb: 1 }}>
        Company
      </Typography>
      <FormControl fullWidth>
        <Select
          value={selectedCompany?.id || ''}
          onChange={(e) => {
            const company = companies.find(
              (company) => company.id === Number(e.target.value)
            );
            onCompanyFilter(company || null);
          }}
          displayEmpty
        >
          <MenuItem value="">
            <em>All Companies</em>
          </MenuItem>
          {companies.map((company) => (
            <MenuItem key={company.id} value={company.id}>
              {company.company_name}
            </MenuItem>
          ))}
        </Select>
      </FormControl>
    </Box>
  );
};
