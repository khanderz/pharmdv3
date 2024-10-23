import React, { useState } from 'react';
import {
  Typography,
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Box,
  Grid,
  IconButton,
} from '@mui/material';
import { FilterList } from '@mui/icons-material';
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
import { SearchPanel } from '@components/molecules/SearchPanel/SearchPanel';

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
          // expandIcon={<FilterList />}
          aria-controls="more-filters-content"
          id="more-filters-header"
        >
          <Box
            flexDirection="column"
            rowGap={2}
            sx={{
              width: '100%',
            }}
          >
            <Box
              flexDirection="row"
              sx={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
              }}
            >
              <Typography variant="h6">Filters</Typography>
              <IconButton onClick={toggleAccordion}>
                <FilterList />
              </IconButton>
            </Box>

            <SearchPanel />
            <Grid
              container
              direction="row"
              justifyContent="space-around"
              alignItems="center"
              columnSpacing={2}
            >
              {/* Company Filter */}
              <Grid item xs={5}>
                <CompanyFilter
                  companies={companies}
                  selectedCompany={selectedCompany}
                  onCompanyFilter={onCompanyFilter}
                />
              </Grid>

              {/* Domain Filter */}
              <Grid item xs={5}>
                <DomainFilter
                  domains={domains}
                  selectedDomain={selectedDomain}
                  onDomainFilter={onDomainFilter}
                />
              </Grid>

              {/* Job Setting Filter */}
              <Grid item xs={2}>
                <JobSettingFilter
                  jobSettings={jobSettings}
                  selectedJobSetting={selectedJobSetting}
                  onJobSettingFilter={onJobSettingFilter}
                  expanded={isExpanded}
                />
              </Grid>
            </Grid>
          </Box>
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
