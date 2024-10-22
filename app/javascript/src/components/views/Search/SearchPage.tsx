import React, { useState } from 'react';
import { Box, Container, Grid, Pagination, Typography } from '@mui/material';
import { SearchPanel } from '@components/molecules/SearchPanel/SearchPanel';
import { FilterPanel } from '@components/organisms/FilterPanel/FilterPanel';
import { JobCard } from '@components/organisms/JobCard/JobCard';
import {
  Company,
  CompanySpecialty,
  HealthcareDomain,
  FundingType,
  CompanySize,
} from '@customtypes/company';
import { Department, JobRole } from '@customtypes/job_role';
import {
  JobCommitment,
  JobSalaryInterval,
  JobSetting,
  JobSalaryCurrency,
} from '@customtypes/job_post';
import { City, State, Country } from '@customtypes/location.types';
import {
  useHealthcareDomains,
  useJobPosts,
  useDepartments,
  useCities,
  useStates,
  useCountries,
  useJobRoles,
  useJobCommitments,
  useJobSettings,
} from '@javascript/hooks';
import {
  LoadingState,
  ErrorState,
  NoMatchState,
} from '@components/views/index';

const POSTS_PER_PAGE = 10;

export const SearchPage = () => {
  const [selectedDomain, setSelectedDomain] = useState<HealthcareDomain | null>(
    null
  );

  /* --------------------- Hooks --------------------- */

  const { jobPosts, filteredJobPosts, setFilteredJobPosts, loading, error } =
    useJobPosts(selectedDomain?.id ?? null);

  const {
    allDomains,
    loading: domainsLoading,
    error: domainsError,
  } = useHealthcareDomains();

  const {
    departments,
    loading: departmentsLoading,
    error: departmentsError,
  } = useDepartments();

  const {
    jobRoles,
    loading: jobRolesLoading,
    error: jobRolesError,
  } = useJobRoles();

  const {
    jobCommitments,
    loading: jobCommitmentsLoading,
    error: jobCommitmentsError,
  } = useJobCommitments();
  const {
    jobSettings,
    loading: jobSettingsLoading,
    error: jobSettingsError,
  } = useJobSettings();

  const { cities, loading: citiesLoading, error: citiesError } = useCities();
  const { states, loading: statesLoading, error: statesError } = useStates();
  const {
    countries,
    loading: countriesLoading,
    error: countriesError,
  } = useCountries();

  /* --------------------- States --------------------- */

  const [currentPage, setCurrentPage] = useState(1);
  const [selectedCompany, setSelectedCompany] = useState<Company | null>(null);
  const [selectedSpecialty, setSelectedSpecialty] =
    useState<CompanySpecialty | null>(null);
  const [selectedDepartment, setSelectedDepartment] =
    useState<Department | null>(null);
  const [selectedJobRole, setSelectedJobRole] = useState<JobRole | null>(null);
  const [selectedCity, setSelectedCity] = useState<string | null>(null);
  const [selectedState, setSelectedState] = useState<string | null>(null);
  const [selectedCountry, setSelectedCountry] = useState<string | null>(null);
  const [selectedJobCommitment, setSelectedJobCommitment] =
    useState<JobCommitment | null>(null);
  const [selectedJobSetting, setSelectedJobSetting] =
    useState<JobSetting | null>(null);

  /* --------------------- Constants --------------------- */

  const totalPages = Math.ceil(filteredJobPosts.length / POSTS_PER_PAGE);

  const noMatchingResults = filteredJobPosts.length === 0;

  const uniqueCompanies: Company[] = Array.from(
    new Map(
      jobPosts.map((jobPost) => [jobPost.company.id, jobPost.company])
    ).values()
  );

  const uniqueSpecialties: CompanySpecialty[] = Array.from(
    new Map(
      jobPosts
        .flatMap((jobPost) => jobPost.company.company_specialties ?? [])
        .map((specialty) => [specialty.value, specialty])
    ).values()
  ).filter(Boolean);

  const uniqueJobRoles: JobRole[] = Array.from(
    jobPosts
      .reduce((map, jobPost) => {
        const jobRole = jobRoles.find(
          (role) => role.id === jobPost.job_role_id
        );
        if (jobRole && !map.has(jobRole.id)) {
          map.set(jobRole.id, jobRole);
        }
        return map;
      }, new Map<number, JobRole>())
      .values()
  );

  const paginatedJobPosts = filteredJobPosts.slice(
    (currentPage - 1) * POSTS_PER_PAGE,
    currentPage * POSTS_PER_PAGE
  );

  const currentlyLoading =
    loading ||
    domainsLoading ||
    departmentsLoading ||
    jobRolesLoading ||
    citiesLoading ||
    statesLoading ||
    countriesLoading ||
    jobCommitmentsLoading ||
    jobSettingsLoading;

  const errors =
    error ||
    domainsError ||
    departmentsError ||
    jobRolesError ||
    citiesError ||
    statesError ||
    countriesError ||
    jobCommitmentsError ||
    jobSettingsError;

  /* --------------------- Handles --------------------- */

  const handleCompanyFilter = (company: Company | null) => {
    setSelectedCompany(company);
    filterJobPosts(company, selectedSpecialty, selectedDomain?.id ?? null);
  };

  const handleDomainFilter = (domain: HealthcareDomain | null) => {
    setSelectedDomain(domain);
    filterJobPosts(selectedCompany, selectedSpecialty, domain?.id ?? null);
  };

  const handleSpecialtyFilter = (specialty: CompanySpecialty | null) => {
    setSelectedSpecialty(specialty);
    filterJobPosts(selectedCompany, specialty, selectedDomain?.id ?? null);
  };

  const handleDepartmentFilter = (department: Department | null) => {
    setSelectedDepartment(department);
    filterJobPosts(
      selectedCompany,
      selectedSpecialty,
      selectedDomain?.id ?? null,
      department
    );
  };

  const handleJobRoleFilter = (jobRole: JobRole | null) => {
    setSelectedJobRole(jobRole);
    filterJobPosts(
      selectedCompany,
      selectedSpecialty,
      selectedDomain?.id ?? null,
      selectedDepartment,
      jobRole
    );
  };

  const handleJobSettingFilter = (jobSetting: JobSetting | null) => {
    setSelectedJobSetting(jobSetting ?? null);
    filterJobPosts(
      selectedCompany,
      selectedSpecialty,
      selectedDomain?.id ?? null,
      selectedDepartment,
      selectedJobRole,
      jobSetting
    );
  };

  const handleJobCommitmentFilter = (jobCommitment: JobCommitment | null) => {
    setSelectedJobCommitment(jobCommitment);
    filterJobPosts(
      selectedCompany,
      selectedSpecialty,
      selectedDomain?.id ?? null,
      selectedDepartment,
      selectedJobRole,
      selectedJobSetting,
      jobCommitment
    );
  };

  // Filter job posts based on selected filters
  const filterJobPosts = (
    company: Company | null,
    specialty: CompanySpecialty | null,
    domain: number | null,
    department: Department | null = null,
    jobRole: JobRole | null = null,
    jobSetting: JobSetting | null = null,
    jobCommitment: JobCommitment | null = null
  ) => {
    let filtered = jobPosts;

    if (company) {
      filtered = filtered.filter(
        (jobPost) => jobPost.company.id === company.id
      );
    }

    if (specialty) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.company_specialties?.some(
          (spec: CompanySpecialty) => spec.id === specialty.id
        )
      );
    }

    if (domain) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.healthcare_domains?.some(
          (dom: HealthcareDomain) => dom.id === domain
        )
      );
    }

    if (department) {
      filtered = filtered.filter(
        (jobPost) => jobPost.department_id === department?.id
      );
    }

    if (jobRole) {
      filtered = filtered.filter(
        (jobPost) => jobPost.job_role_id === jobRole.id
      );
    }

    if (jobSetting) {
      filtered = filtered.filter(
        (jobPost) => jobPost.job_setting_id === jobSetting.id
      );
    }

    if (jobCommitment) {
      filtered = filtered.filter(
        (jobPost) => jobPost.job_commitment_id === jobCommitment.id
      );
    }

    setFilteredJobPosts(filtered);
    setCurrentPage(1);
  };

  const handlePageChange = (
    event: React.ChangeEvent<unknown>,
    page: number
  ) => {
    setCurrentPage(page);
  };

  const resetFilters = () => {
    setSelectedCompany(null);
    setSelectedSpecialty(null);
    setSelectedDomain(null);
    setSelectedDepartment(null);
    setSelectedJobRole(null);
    setSelectedJobSetting(null);
    setSelectedJobCommitment(null);
    setFilteredJobPosts(jobPosts);
  };

  const getNoResultsMessage = () => {
    const filters = [];

    if (selectedCompany) {
      filters.push(`for company "${selectedCompany.company_name}"`);
    }

    if (selectedSpecialty) {
      filters.push(`with specialty "${selectedSpecialty}"`);
    }

    if (selectedDomain) {
      filters.push(`in domain "${selectedDomain.value}"`);
    }

    if (selectedDepartment) {
      filters.push(`for department "${selectedDepartment.dept_name}"`);
    }

    if (selectedJobRole) {
      filters.push(`for job role "${selectedJobRole.role_name}"`);
    }

    if (selectedJobSetting) {
      filters.push(`for job setting "${selectedJobSetting}"`);
    }

    if (selectedJobCommitment) {
      filters.push(
        `for job commitment "${selectedJobCommitment.commitment_name}"`
      );
    }

    let message = 'No matching job posts';

    if (filters.length > 0) {
      const lastFilter = filters.pop();
      if (filters.length > 0) {
        message += ` ${filters.join(', ')} and ${lastFilter}.`;
      } else {
        message += ` ${lastFilter}.`;
      }
    } else {
      message += '.';
    }

    return message;
  };
  console.log({ jobPosts });
  return (
    <Container
      sx={{
        height: '100vh',
        width: '100vw',
        display: 'flex',
        flexDirection: 'column',
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

          <SearchPanel />

          <Grid container spacing={4} data-testid="search-page-container">
            <Grid item xs={12} md={3} data-testid="filter-panel-grid">
              <FilterPanel
                companies={uniqueCompanies}
                selectedCompany={selectedCompany}
                onCompanyFilter={handleCompanyFilter}
                specialties={uniqueSpecialties}
                selectedSpecialty={selectedSpecialty}
                onSpecialtyFilter={handleSpecialtyFilter}
                domains={allDomains}
                selectedDomain={selectedDomain}
                onDomainFilter={handleDomainFilter}
                departments={departments}
                selectedDepartment={selectedDepartment}
                onDepartmentFilter={handleDepartmentFilter}
                jobRoles={uniqueJobRoles}
                selectedJobRole={selectedJobRole}
                onJobRoleFilter={handleJobRoleFilter}
                jobSettings={jobSettings}
                selectedJobSetting={selectedJobSetting}
                onJobSettingFilter={handleJobSettingFilter}
                jobCommitments={jobCommitments}
                selectedJobCommitment={selectedJobCommitment}
                onJobCommitmentFilter={handleJobCommitmentFilter}
              />
            </Grid>

            <Grid item xs={12} md={9} data-testid="job-post-grid">
              {noMatchingResults ? (
                <NoMatchState
                  message={getNoResultsMessage()}
                  onReset={resetFilters}
                />
              ) : (
                <>
                  <Grid container spacing={3} data-testid="job-cards-container">
                    {paginatedJobPosts.map((jobPost) => (
                      <Grid item xs={12} key={jobPost.id}>
                        <JobCard
                          title={jobPost.job_title}
                          company_name={jobPost.company.company_name}
                          job_applyUrl={jobPost.job_url}
                          company_specialty={
                            jobPost.company.company_specialties[0]?.value
                          }
                          job_posted={jobPost.job_posted}
                          job_location={jobPost.job_locations[0]}
                          job_commitment={jobPost.job_commitment}
                          healthcare_domains={
                            jobPost.company.healthcare_domains ?? []
                          }
                        />
                      </Grid>
                    ))}
                  </Grid>

                  <Box
                    sx={{ mt: 4, display: 'flex', justifyContent: 'center' }}
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
