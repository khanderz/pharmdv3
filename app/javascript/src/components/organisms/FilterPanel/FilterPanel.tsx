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
import { Button } from '@components/atoms';

interface FilterPanelProps
  extends CompanyFilterProps,
    DomainFilterProps,
    DepartmentFilterProps,
    SpecialtyFilterProps,
    JobRoleFilterProps,
    JobSettingFilterProps,
    JobCommitmentFilterProps {
  resetFilters: () => void;
}

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
  resetFilters,
  domainsLoading,
  departmentsLoading,
  jobRolesLoading,
  jobCommitmentsLoading,
  jobSettingsLoading,
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
            <Box
              flexDirection="row"
              sx={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
              }}
            >
              <Button
                data-testid={`filter-panel-reset-button`}
                variant="contained"
                color="secondary"
                sx={{ m: 2, float: 'right' }}
                onClick={() => {
                  resetFilters();
                  // setExpanded(false);
                }}
              >
                Reset
              </Button>
              <IconButton
                onClick={toggleAccordion}
                sx={{ color: 'primary.main' }}
              >
                <FilterList />
              </IconButton>
            </Box>
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
                domainsLoading={domainsLoading}
              />
            </Grid>

            {/* Job Setting Filter */}
            <Grid item xs={2}>
              <JobSettingFilter
                jobSettings={jobSettings}
                selectedJobSettings={selectedJobSettings}
                onJobSettingFilter={onJobSettingFilter}
                expanded={isExpanded}
                jobSettingsLoading={jobSettingsLoading}
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
            departmentsLoading={departmentsLoading}
          />

          {/* Job Role Filter */}
          <JobRoleFilter
            jobRoles={jobRoles}
            selectedJobRoles={selectedJobRoles}
            onJobRoleFilter={onJobRoleFilter}
            jobRolesLoading={jobRolesLoading}
          />

          {/* Job Commitment Filter */}
          <JobCommitmentFilter
            jobCommitments={jobCommitments}
            selectedJobCommitments={selectedJobCommitments}
            onJobCommitmentFilter={onJobCommitmentFilter}
            jobCommitmentsLoading={jobCommitmentsLoading}
          />
        </AccordionDetails>
      </Box>
    </Accordion>
  );
};
