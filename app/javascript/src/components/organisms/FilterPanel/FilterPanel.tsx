import React from 'react';
import { Box as MuiBox, Typography } from '@mui/material';
import {
  CompanyFilter,
  CompanyFilterProps,
  DomainFilter,
  DomainFilterProps,
  DepartmentFilter,
  DepartmentFilterProps,
  SpecialtyFilter,
  SpecialtyFilterProps,
  JobRoleFilter,
  JobRoleFilterProps,
  JobSettingFilter,
  JobSettingFilterProps,
  JobCommitmentFilter,
  JobCommitmentFilterProps,
} from '@components/molecules/Filters';
import { Box, Button } from '@components/atoms/index';

interface FilterPanelProps
  extends CompanyFilterProps,
    DomainFilterProps,
    DepartmentFilterProps,
    SpecialtyFilterProps,
    JobRoleFilterProps,
    JobSettingFilterProps,
    JobCommitmentFilterProps {}

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
  domains,
  selectedDomain,
  onDomainFilter,
  jobRoles,
  selectedJobRole,
  onJobRoleFilter,
  jobSettings,
  selectedJobSetting,
  onJobSettingFilter,
  jobCommitments,
  selectedJobCommitment,
  onJobCommitmentFilter,
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
      <SpecialtyFilter
        specialties={specialties}
        selectedSpecialty={selectedSpecialty}
        onSpecialtyFilter={onSpecialtyFilter}
      />

      {/* Department Filter */}
      <DepartmentFilter
        departments={departments}
        selectedDepartment={selectedDepartment}
        onDepartmentFilter={onDepartmentFilter}
      />

      {/* Job Role Filter */}
      <JobRoleFilter
        jobRoles={jobRoles}
        selectedJobRole={selectedJobRole}
        onJobRoleFilter={onJobRoleFilter}
      />

      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <Typography variant="body1">Location</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          United States
        </Button>
      </MuiBox>

      {/* Job Commitment Filter */}
      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <JobCommitmentFilter
          jobCommitments={jobCommitments}
          selectedJobCommitment={selectedJobCommitment}
          onJobCommitmentFilter={onJobCommitmentFilter}
        />
      </MuiBox>

      {/* Job Setting Filter */}
      <MuiBox sx={{ mt: 2, borderRadius: '2px' }}>
        <JobSettingFilter
          jobSettings={jobSettings}
          selectedJobSetting={selectedJobSetting}
          onJobSettingFilter={onJobSettingFilter}
        />
      </MuiBox>
    </Box>
  );
};
