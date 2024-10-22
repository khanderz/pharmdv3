import React, { useState } from 'react';
import { Box, Container, Grid, Pagination, Typography } from '@mui/material';
import { SearchPanel } from '@components/molecules/SearchPanel/SearchPanel';
import { FilterPanel } from '@components/organisms/FilterPanel/FilterPanel';
import { JobCard } from '@components/organisms/JobCard/JobCard';
import {
  Company,
  CompanySpecialty,
  HealthcareDomain,
} from '@customtypes/company';
import { Department, Team } from '@customtypes/job_role';
import {
  useHealthcareDomains,
  useJobPosts,
  useDepartments,
  useTeams,
  useCompanySpecialties,
  useCities,
  useStates,
  useCountries,
  useJobRoles,
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
    companySpecialties,
    loading: specialtiesLoading,
    error: specialtiesError,
  } = useCompanySpecialties();

  const {
    jobRoles,
    loading: jobRolesLoading,
    error: jobRolesError,
  } = useJobRoles();

  const { cities, loading: citiesLoading, error: citiesError } = useCities();
  const { states, loading: statesLoading, error: statesError } = useStates();
  const {
    countries,
    loading: countriesLoading,
    error: countriesError,
  } = useCountries();

  const { teams, loading: teamsLoading, error: teamsError } = useTeams();

  /* --------------------- States --------------------- */

  const [currentPage, setCurrentPage] = useState(1);
  const [selectedCompany, setSelectedCompany] = useState<Company | null>(null);
  const [selectedSpecialty, setSelectedSpecialty] = useState<
    CompanySpecialty['value'] | null
  >(null);
  const [selectedDepartment, setSelectedDepartment] =
    useState<Department | null>(null);
  const [selectedTeam, setSelectedTeam] = useState<Team | null>(null);

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

  const paginatedJobPosts = filteredJobPosts.slice(
    (currentPage - 1) * POSTS_PER_PAGE,
    currentPage * POSTS_PER_PAGE
  );

  const currentlyLoading =
    loading ||
    domainsLoading ||
    departmentsLoading ||
    teamsLoading ||
    specialtiesLoading ||
    jobRolesLoading ||
    citiesLoading ||
    statesLoading ||
    countriesLoading;

  const errors =
    error ||
    domainsError ||
    departmentsError ||
    teamsError ||
    specialtiesError ||
    jobRolesError ||
    citiesError ||
    statesError ||
    countriesError;

  /* --------------------- Handles --------------------- */

  const handleCompanyFilter = (company: Company | null) => {
    setSelectedCompany(company);
    filterJobPosts(company, selectedSpecialty, selectedDomain?.id ?? null);
  };

  const handleSpecialtyFilter = (
    specialty: CompanySpecialty['value'] | null
  ) => {
    setSelectedSpecialty(specialty);
    filterJobPosts(selectedCompany, specialty, selectedDomain?.id ?? null);
  };

  const handleDomainFilter = (domain: HealthcareDomain | null) => {
    setSelectedDomain(domain);
    filterJobPosts(selectedCompany, selectedSpecialty, domain?.id ?? null);
  };

  const handleDepartmentFilter = (department: Department | null) => {
    setSelectedDepartment(department);
    filterJobPosts(
      selectedCompany,
      selectedSpecialty,
      selectedDomain?.id ?? null,
      department,
      selectedTeam
    );
  };

  const handleTeamFilter = (team: Team | null) => {
    setSelectedTeam(team);
    filterJobPosts(
      selectedCompany,
      selectedSpecialty,
      selectedDomain?.id ?? null,
      selectedDepartment,
      team
    );
  };

  // Filter job posts based on selected filters
  const filterJobPosts = (
    company: Company | null,
    specialty: CompanySpecialty['value'] | null,
    domain: number | null,
    department: Department | null = null,
    team: Team | null = null
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
          (spec: CompanySpecialty) => spec.value === specialty
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

    if (team) {
      filtered = filtered.filter((jobPost) => jobPost.team_id === team?.id);
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
    setSelectedTeam(null);
    setFilteredJobPosts(jobPosts);
  };

  const getNoResultsMessage = () => {
    let message = 'No matching job posts';

    if (selectedCompany) {
      message += ` for company "${selectedCompany.company_name}"`;
    }

    if (selectedSpecialty) {
      message += ` with specialty "${selectedSpecialty}"`;
    }

    if (selectedDomain) {
      message += ` in domain "${selectedDomain.value}"`;
    }

    if (selectedDepartment) {
      message += ` for department "${selectedDepartment.dept_name}"`;
    }

    if (selectedTeam) {
      message += ` in team "${selectedTeam.team_name}"`;
    }

    return message + '.';
  };

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
                teams={teams}
                selectedTeam={selectedTeam}
                onTeamFilter={handleTeamFilter}
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
