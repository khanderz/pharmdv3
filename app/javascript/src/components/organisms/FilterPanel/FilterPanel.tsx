import React, { useState } from 'react';
import {
  IconButton,
  Typography,
  Box as MuiBox,
  Accordion,
  AccordionDetails,
  AccordionSummary,
} from '@mui/material';
import { FilterList } from '@mui/icons-material';
import { Box, Button } from '@components/atoms/index';
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
  const [isExpanded, setExpanded] = useState(false);

  const toggleAccordion = () => {
    setExpanded(!isExpanded);
  };

  return (
    <>
      <Accordion
        expanded={isExpanded}
        onChange={toggleAccordion}
        sx={{
          border: '1px solid',
          borderColor: 'primary.main',
          borderRadius: '2px',
        }}
      >
        <AccordionSummary
          expandIcon={<FilterList />}
          aria-controls="more-filters-content"
          id="more-filters-header"
        >
          <Typography variant="h6" sx={{ mb: 2 }}>
            Filters
          </Typography>

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

          {/* Job Setting Filter */}
          <JobSettingFilter
            jobSettings={jobSettings}
            selectedJobSetting={selectedJobSetting}
            onJobSettingFilter={onJobSettingFilter}
            expanded={isExpanded}
          />
        </AccordionSummary>
        {/* <Box sx={{ p: 2 }} role="presentation"> */}

        <AccordionDetails>
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

          {/* Job Commitment Filter */}
          <JobCommitmentFilter
            jobCommitments={jobCommitments}
            selectedJobCommitment={selectedJobCommitment}
            onJobCommitmentFilter={onJobCommitmentFilter}
          />
        </AccordionDetails>
        {/* </Box> */}
      </Accordion>
    </>
  );
};
