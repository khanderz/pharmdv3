import React, { useState } from 'react';
import {
  Typography,
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
import { Accordion } from '@components/atoms/Accordion';

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
  selectedCompanies,
  onCompanyFilter,
  specialties,
  selectedSpecialties,
  onSpecialtyFilter,
  departments,
  selectedDepartments,
  onDepartmentFilter,
  domains,
  selectedDomains,
  onDomainFilter,
  jobRoles,
  selectedJobRoles,
  onJobRoleFilter,
  jobSettings,
  selectedJobSettings,
  onJobSettingFilter,
  jobCommitments,
  selectedJobCommitments,
  onJobCommitmentFilter,
}: FilterPanelProps) => {
  const [isExpanded, setExpanded] = useState(true);

  const toggleAccordion = () => {
    setExpanded(!isExpanded);
  };

  return (
    <Accordion expanded={isExpanded} componentName="filter-panel">
      <AccordionSummary
        aria-controls="more-filters-content"
        id="more-filters-header"
        sx={{
          '&.MuiButtonBase-root, & .MuiAccordionSummary-root, & .MuiAccordionSummary-content':
            {
              cursor: 'default',
            },
        }}
      >
        <Box
          data-testid="non-expanded-filters"
          flexDirection="column"
          rowGap={2}
          sx={{
            display: 'flex',
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
            <Typography variant="h5">Filters</Typography>
            <IconButton
              onClick={toggleAccordion}
              sx={{ color: 'primary.main' }}
            >
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
                selectedCompanies={selectedCompanies}
                onCompanyFilter={onCompanyFilter}
              />
            </Grid>

            {/* Domain Filter */}
            <Grid item xs={5}>
              <DomainFilter
                domains={domains}
                selectedDomains={selectedDomains}
                onDomainFilter={onDomainFilter}
              />
            </Grid>

            {/* Job Setting Filter */}
            <Grid item xs={2}>
              <JobSettingFilter
                jobSettings={jobSettings}
                selectedJobSettings={selectedJobSettings}
                onJobSettingFilter={onJobSettingFilter}
                expanded={isExpanded}
              />
            </Grid>
          </Grid>
        </Box>
      </AccordionSummary>
      <Box role="presentation" data-testid="expanded-filters">
        <AccordionDetails>
          {/* Specialty Filter */}
          <SpecialtyFilter
            specialties={specialties}
            selectedSpecialties={selectedSpecialties}
            onSpecialtyFilter={onSpecialtyFilter}
          />

          {/* Department Filter */}
          <DepartmentFilter
            departments={departments}
            selectedDepartments={selectedDepartments}
            onDepartmentFilter={onDepartmentFilter}
          />

          {/* Job Role Filter */}
          <JobRoleFilter
            jobRoles={jobRoles}
            selectedJobRoles={selectedJobRoles}
            onJobRoleFilter={onJobRoleFilter}
          />

          {/* Job Commitment Filter */}
          <JobCommitmentFilter
            jobCommitments={jobCommitments}
            selectedJobCommitments={selectedJobCommitments}
            onJobCommitmentFilter={onJobCommitmentFilter}
          />
        </AccordionDetails>
      </Box>
    </Accordion>
  );
};
