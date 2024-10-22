import React from "react";
import { Box as MuiBox, Typography, Select, MenuItem, FormControl } from "@mui/material";
import { CompanyFilter } from "@components/molecules/Filters/CompanyFilter/CompanyFilter";
import { Company, CompanySpecialty, HealthcareDomain } from "@customtypes/company";
import { Department, Team } from "@customtypes/job_role";
import { Button } from "@components/atoms/Button";
import { Box } from "@components/atoms/Box";


interface FilterPanelProps {
  companies: Company['company_name'][];
  selectedCompany: Company['company_name'] | null;
  onCompanyFilter: (company_name: Company['company_name'] | null) => void;

  specialties: CompanySpecialty[]
  selectedSpecialty: CompanySpecialty['value'] | null;
  onSpecialtyFilter: (specialty: CompanySpecialty['value'] | null) => void;

  domains: HealthcareDomain[];
  selectedDomain: HealthcareDomain | null;
  onDomainFilter: (domain: HealthcareDomain | null) => void;

  departments: Department[];
  selectedDepartment: Department['dept_name'] | null;
  onDepartmentFilter: (department: Department['dept_name'] | null) => void;

  teams: Team[];
  selectedTeam: Team['team_name'] | null;
  onTeamFilter: (team: Team['team_name'] | null) => void;
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
    <Box sx={{ p: 2 }}
      data-testid="filter-panel-box">
      <Typography variant="h6">Filters</Typography>

      {/* Company Filter */}
      <CompanyFilter
        companies={companies}
        selectedCompany={selectedCompany}
        onCompanyFilter={onCompanyFilter}
      />

      {/* Domain Filter */}
      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <Typography variant="body1">Domain</Typography>
        <FormControl fullWidth>
          <Select
            value={selectedDomain?.key || ''}
            onChange={(e) => {
              const selectedDomain = domains.find(domain => domain.key === e.target.value);
              onDomainFilter(selectedDomain || null);
            }}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Domains</em>
            </MenuItem>
            {domains.map((domain) => (
              <MenuItem key={domain.key} value={domain.key}>
                {domain.value}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </MuiBox>


      {/* Specialty Filter */}
      <MuiBox sx={{ mt: 2, borderRadius: '2px', }}>
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
      <MuiBox sx={{ mt: 2, borderRadius: '2px', }}>
        <Typography variant="body1">Department</Typography>
        <FormControl fullWidth  >
          <Select value={selectedDepartment || ''}
            onChange={(e) => onDepartmentFilter(e.target.value || null)}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Departments</em>
            </MenuItem>
            {departments.map((dept) => (
              <MenuItem key={dept.department_id} value={dept.dept_name}>
                {dept.dept_name}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </MuiBox>

      {/* Team Filter */}
      <MuiBox sx={{ mt: 2, borderRadius: '2px', }}>
        <Typography variant="body1">Team</Typography>
        <FormControl fullWidth  >
          <Select value={selectedTeam || ''}
            onChange={(e) => onTeamFilter(e.target.value || null)}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Teams</em>
            </MenuItem>
            {teams.map((team) => (
              <MenuItem key={team.team_id} value={team.team_name}>
                {team.team_name}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </MuiBox>

      <MuiBox sx={{ mt: 2, borderRadius: '2px', }}>
        <Typography variant="body1">Location</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          United States
        </Button>
      </MuiBox>

      <MuiBox sx={{ mt: 2, borderRadius: '2px', }}>
        <Typography variant="body1">Job Type</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Full-time
        </Button>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Part-time
        </Button>
      </MuiBox>

      <MuiBox sx={{ mt: 2, borderRadius: '2px', }}>
        <Typography variant="body1">Remote</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Remote
        </Button>
      </MuiBox>
    </Box>
  );
};
