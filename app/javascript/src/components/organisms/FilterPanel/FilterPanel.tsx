import React from 'react';
import {
  Box as MuiBox,
  Typography,
  Select,
  MenuItem,
  FormControl,
} from '@mui/material';
import { CompanySpecialty } from '@customtypes/company';
import {
  CompanyFilter,
  CompanyFilterProps,
  DomainFilter,
  DomainFilterProps,
  DepartmentFilter,
  DepartmentFilterProps,
  TeamFilter,
  TeamFilterProps,
} from '@components/molecules/Filters/index';
import { Box, Button } from '@components/atoms/index';

interface FilterPanelProps
  extends CompanyFilterProps,
    DomainFilterProps,
    DepartmentFilterProps,
    TeamFilterProps {
  specialties: CompanySpecialty[];
  selectedSpecialty: CompanySpecialty['value'] | null;
  onSpecialtyFilter: (specialty: CompanySpecialty['value'] | null) => void;
}

export const FilterPanel = ({
  companies,
  selectedCompany,
  onCompanyFilter,
  specialties,
  selectedSpecialty,
  onSpecialtyFilter,
  departments,
  selectedDepartment,
  onDepartmentFilter,
  teams,
  selectedTeam,
  onTeamFilter,
  domains,
  selectedDomain,
  onDomainFilter,
}: FilterPanelProps) => {
  return (
    <Box sx={{ p: 2 }} data-testid="filter-panel-box">
      <Typography variant="h6">Filters</Typography>

      {/* Company Filter */}
      <CompanyFilter
        companies={companies}
        selectedCompany={selectedCompany}
        onCompanyFilter={onCompanyFilter}
      />

      {/* Domain Filter */}
      <DomainFilter
        domains={domains}
        selectedDomain={selectedDomain}
        onDomainFilter={onDomainFilter}
      />

      {/* Specialty Filter */}
      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <Typography variant="body1">Specialty</Typography>
        <FormControl fullWidth>
          <Select
            value={selectedSpecialty || ''}
            onChange={(e) => onSpecialtyFilter(e.target.value || null)}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Specialties</em>
            </MenuItem>
            {specialties.map((specialty) => (
              <MenuItem key={specialty.key} value={specialty.value}>
                {specialty.value}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </MuiBox>

      {/* Department Filter */}
      <DepartmentFilter
        departments={departments}
        selectedDepartment={selectedDepartment}
        onDepartmentFilter={onDepartmentFilter}
      />

      {/* Team Filter */}
      <TeamFilter
        teams={teams}
        selectedTeam={selectedTeam}
        onTeamFilter={onTeamFilter}
      />

      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <Typography variant="body1">Location</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          United States
        </Button>
      </MuiBox>

      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <Typography variant="body1">Job Type</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Full-time
        </Button>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Part-time
        </Button>
      </MuiBox>

      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <Typography variant="body1">Setting</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Remote
        </Button>
      </MuiBox>
    </Box>
  );
};
