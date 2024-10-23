import React from 'react';
import { Box, Grid, Pagination, Typography } from '@mui/material';
import { FilterPanel } from '@components/organisms/FilterPanel/FilterPanel';
import { JobCard } from '@components/organisms/JobCard/JobCard';
import {
  JobCommitment,
  JobSalaryInterval,
  JobSetting,
  JobSalaryCurrency,
} from '@customtypes/job_post';
import {
  LoadingState,
  ErrorState,
  NoMatchState,
} from '@components/views/index';
import { Container } from '@components/atoms/Paper';
import { useSearchPageLogic } from './SearchPage.logic';

export const SearchPage = () => {
  const {
    errors,
    currentlyLoading,
    uniqueCompanies,
    selectedCompanies,
    handleCompanyFilter,
    uniqueSpecialties,
    selectedSpecialties,
    handleSpecialtyFilter,
    allDomains,
    selectedDomains,
    handleDomainFilter,
    departments,
    selectedDepartments,
    handleDepartmentFilter,
    uniqueJobRoles,
    selectedJobRoles,
    handleJobRoleFilter,
    jobSettings,
    selectedJobSettings,
    handleJobSettingFilter,
    jobCommitments,
    selectedJobCommitments,
    handleJobCommitmentFilter,
    noMatchingResults,
    getNoResultsMessage,
    resetFilters,
    paginatedJobPosts,
    totalPages,
    currentPage,
    handlePageChange,
  } = useSearchPageLogic();

  return (
    <Container
      dataTestId="search"
      sx={{
        flexDirection: 'column',
        justifyContent: 'flex-start',
      }}
    >
      {errors ? (
        <ErrorState errors={errors} />
      ) : currentlyLoading ? (
        <LoadingState />
      ) : (
        <>
          <Box
            justifyContent="center"
            display="flex"
            sx={{ margin: 2 }}
            data-testid="search-page-title"
          >
            <Typography variant="title">Search for a job post</Typography>
          </Box>

          <Grid container spacing={4} data-testid="search-page-container">
            <Grid item xs={12} data-testid="filter-panel-grid">
              <FilterPanel
                companies={uniqueCompanies}
                selectedCompanies={selectedCompanies}
                onCompanyFilter={handleCompanyFilter}
                specialties={uniqueSpecialties}
                selectedSpecialties={selectedSpecialties}
                onSpecialtyFilter={handleSpecialtyFilter}
                domains={allDomains}
                selectedDomains={selectedDomains}
                onDomainFilter={handleDomainFilter}
                departments={departments}
                selectedDepartments={selectedDepartments}
                onDepartmentFilter={handleDepartmentFilter}
                jobRoles={uniqueJobRoles}
                selectedJobRoles={selectedJobRoles}
                onJobRoleFilter={handleJobRoleFilter}
                jobSettings={jobSettings}
                selectedJobSettings={selectedJobSettings}
                onJobSettingFilter={handleJobSettingFilter}
                jobCommitments={jobCommitments}
                selectedJobCommitments={selectedJobCommitments}
                onJobCommitmentFilter={handleJobCommitmentFilter}
              />
            </Grid>

            <Grid item xs={12} data-testid="job-post-grid">
              {noMatchingResults ? (
                <NoMatchState
                  message={getNoResultsMessage()}
                  onReset={resetFilters}
                />
              ) : (
                <>
                  <Grid container spacing={3} data-testid="job-cards-container">
                    {paginatedJobPosts.map((jobPost) => {
                      const jobCommitmentType = jobCommitments.find(
                        (commitment) =>
                          commitment.id === jobPost.job_commitment_id
                      );

                      const companySpecialties =
                        jobPost.company.company_specialties.map(
                          (specialty) => specialty.value
                        );

                      const jobSetting = jobSettings.find(
                        (setting) => setting.id === jobPost.job_setting_id
                      );

                      const domains = jobPost.company.company_domains.map(
                        (domain) => domain.healthcare_domain['value']
                      );

                      const locations = Array.isArray(jobPost.job_locations)
                        ? jobPost.job_locations.map((location) => location)
                        : [jobPost.job_locations];

                      return (
                        <Grid item xs={12} key={jobPost.id}>
                          <JobCard
                            title={jobPost.job_title}
                            company_name={jobPost.company.company_name}
                            job_applyUrl={jobPost.job_url}
                            company_specialty={companySpecialties}
                            job_posted={jobPost.job_posted}
                            job_location={locations}
                            job_setting={
                              jobSetting?.setting_name as JobSetting['setting_name']
                            }
                            job_commitment={
                              jobCommitmentType?.commitment_name as JobCommitment['commitment_name']
                            }
                            healthcare_domains={domains}
                          />
                        </Grid>
                      );
                    })}
                  </Grid>

                  <Box
                    sx={{ my: 4, display: 'flex', justifyContent: 'center' }}
                    data-testid="pagination-box"
                  >
                    <Pagination
                      count={totalPages}
                      page={currentPage}
                      onChange={handlePageChange}
                      color="primary"
                    />
                  </Box>
                </>
              )}
            </Grid>
          </Grid>
        </>
      )}
    </Container>
  );
};
