import React from 'react';
import {
  Box as MuiBox,
  Typography,
  Select,
  MenuItem,
  FormControl,
} from '@mui/material';
import { CompanySpecialty, HealthcareDomain } from '@customtypes/company';
import { Department, Team } from '@customtypes/job_role';
import { Button } from '@components/atoms/Button';
import { Box } from '@components/atoms/Box';
import {
  CompanyFilter,
  CompanyFilterProps,
  DomainFilter,
  DomainFilterProps,
} from '@components/molecules/Filters/index';

interface FilterPanelProps extends CompanyFilterProps, DomainFilterProps {
  specialties: CompanySpecialty[];
  selectedSpecialty: CompanySpecialty['value'] | null;
  onSpecialtyFilter: (specialty: CompanySpecialty['value'] | null) => void;

  departments: Department[];
  selectedDepartment: Department | null;
  onDepartmentFilter: (department: Department | null) => void;

  teams: Team[];
  selectedTeam: Team | null;
  onTeamFilter: (team: Team | null) => void;
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
      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <Typography variant="body1">Department</Typography>
        <FormControl fullWidth>
          <Select
            value={selectedDepartment?.id || ''}
            onChange={(e) => {
              const selectedDept = departments.find(
                (dept) => dept.id === e.target.value
              );
              onDepartmentFilter(selectedDept || null);
            }}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Departments</em>
            </MenuItem>
            {departments.map((dept) => (
              <MenuItem key={dept.id} value={dept.id}>
                {dept.dept_name}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </MuiBox>

      {/* Team Filter */}
      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <Typography variant="body1">Team</Typography>
        <FormControl fullWidth>
          <Select
            value={selectedTeam?.id || ''}
            onChange={(e) => {
              const selectedTeam = teams.find(
                (team) => team.id === e.target.value
              );
              onTeamFilter(selectedTeam || null);
            }}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Teams</em>
            </MenuItem>
            {teams.map((team) => (
              <MenuItem key={team.id} value={team.id}>
                {team.team_name}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </MuiBox>

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
        <Typography variant="body1">Remote</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Remote
        </Button>
      </MuiBox>
    </Box>
  );
};
