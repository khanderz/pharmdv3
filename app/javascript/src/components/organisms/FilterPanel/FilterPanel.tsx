import React from "react";
import { Box, Typography, Select, MenuItem, Button, FormControl, InputLabel } from "@mui/material";
import { Company, CompanySpecialty } from "../../../types/company.types";
import { JobPost } from "../../../types/job_post.types";
import { CompanyFilter } from "../../molecules/Filters/CompanyFilter/CompanyFilter";

interface FilterPanelProps {
  companies: Company['company_name'][];
  selectedCompany: Company['company_name'] | null;
  onCompanyFilter: (company_name: Company['company_name'] | null) => void;
  specialties: CompanySpecialty['value'][];
  selectedSpecialty: CompanySpecialty['value'] | null;
  onSpecialtyFilter: (specialty: CompanySpecialty['value'] | null) => void;
  departments: JobPost['job_dept'][];
  selectedDepartment: JobPost['job_dept'] | null;
  onDepartmentFilter: (department: JobPost['job_dept'] | null) => void;
  teams: JobPost['job_team'][];
  selectedTeam: JobPost['job_team'] | null;
  onTeamFilter: (team: JobPost['job_team'] | null) => void;
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
}: FilterPanelProps) => {
  return (
    <Box sx={{ border: '1px solid #e0e0e0', borderRadius: '8px', p: 2 }}>
      <Typography variant="h6">Filters</Typography>

      {/* Company Filter */}
      <CompanyFilter
        companies={companies}
        selectedCompany={selectedCompany}
        onCompanyFilter={onCompanyFilter}
      />

      {/* Specialty Filter */}
      <Box sx={{ mt: 2 }}>
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
            {specialties.map((specialty, index) => (
              <MenuItem key={index} value={specialty}>
                {specialty}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </Box>

      {/* Department Filter */}
      <Box sx={{ mt: 2 }}>
        <Typography variant="body1">Department</Typography>
        <FormControl fullWidth  >
          <Select value={selectedDepartment || ''}
            onChange={(e) => onDepartmentFilter(e.target.value || null)}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Departments</em>
            </MenuItem>
            {departments.map((dept, index) => (
              <MenuItem key={index} value={dept}>
                {dept}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </Box>

      {/* Team Filter */}
      <Box sx={{ mt: 2 }}>
        <Typography variant="body1">Team</Typography>
        <FormControl fullWidth  >
          <Select value={selectedTeam || ''}
            onChange={(e) => onTeamFilter(e.target.value || null)}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Teams</em>
            </MenuItem>
            {teams.map((team, index) => (
              <MenuItem key={index} value={team}>
                {team}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </Box>

      <Box sx={{ mt: 2 }}>
        <Typography variant="body1">Location</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          United States
        </Button>
      </Box>

      <Box sx={{ mt: 2 }}>
        <Typography variant="body1">Job Type</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Full-time
        </Button>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Part-time
        </Button>
      </Box>

      <Box sx={{ mt: 2 }}>
        <Typography variant="body1">Remote</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Remote
        </Button>
      </Box>
    </Box>
  );
};
