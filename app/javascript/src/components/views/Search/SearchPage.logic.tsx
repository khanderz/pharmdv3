import React, { useEffect, useState } from 'react';
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

const POSTS_PER_PAGE = 10;

export const useSearchPageLogic = () => {
  const [selectedDomains, setSelectedDomains] = useState<HealthcareDomain[]>(
    []
  );

  /* --------------------- Hooks --------------------- */

  const { jobPosts, filteredJobPosts, setFilteredJobPosts, loading, error } =
    useJobPosts(
      selectedDomains.length > 0
        ? selectedDomains.map((domain) => domain.id)
        : null
    );

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
  const [selectedCompanies, setSelectedCompanies] = useState<Company[]>([]);
  const [selectedSpecialties, setSelectedSpecialties] = useState<
    CompanySpecialty[]
  >([]);
  const [selectedDepartments, setSelectedDepartments] = useState<Department[]>(
    []
  );
  const [selectedJobRoles, setSelectedJobRoles] = useState<JobRole[]>([]);
  const [selectedJobSettings, setSelectedJobSettings] = useState<JobSetting[]>(
    []
  );
  const [selectedJobCommitments, setSelectedJobCommitments] = useState<
    JobCommitment[]
  >([]);
  const [selectedCity, setSelectedCity] = useState<string | null>(null);
  const [selectedState, setSelectedState] = useState<string | null>(null);
  const [selectedCountry, setSelectedCountry] = useState<string | null>(null);

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

  const handleCompanyFilter = (companies: Company[]) => {
    setSelectedCompanies(companies);
  };

  const handleDomainFilter = (domains: HealthcareDomain[]) => {
    setSelectedDomains(domains);
  };

  const handleSpecialtyFilter = (specialties: CompanySpecialty[]) => {
    setSelectedSpecialties(specialties);
  };

  const handleDepartmentFilter = (departments: Department[]) => {
    setSelectedDepartments(departments);
  };

  const handleJobRoleFilter = (jobRoles: JobRole[]) => {
    setSelectedJobRoles(jobRoles);
  };

  const handleJobSettingFilter = (jobSettings: JobSetting[]) => {
    setSelectedJobSettings(jobSettings);
  };

  const handleJobCommitmentFilter = (jobCommitments: JobCommitment[]) => {
    setSelectedJobCommitments(jobCommitments);
  };

  const filterJobPosts = (
    companies: Company[],
    specialties: CompanySpecialty[],
    domains: HealthcareDomain[],
    departments: Department[],
    jobRoles: JobRole[],
    jobSettings: JobSetting[],
    jobCommitments: JobCommitment[]
  ) => {
    let filtered = jobPosts;

    if (companies.length > 0) {
      filtered = filtered.filter((jobPost) =>
        companies.some((company) => jobPost.company.id === company.id)
      );
    }

    if (specialties.length > 0) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.company_specialties?.some((spec) =>
          specialties.some((selectedSpec) => selectedSpec.id === spec.id)
        )
      );
    }

    if (domains.length > 0) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.company_domains?.some((dom) =>
          domains.some((selectedDomain) => selectedDomain.id === dom.id)
        )
      );
    }

    if (departments.length > 0) {
      filtered = filtered.filter((jobPost) =>
        departments.some((dept) => jobPost.department_id === dept.id)
      );
    }

    if (jobRoles.length > 0) {
      filtered = filtered.filter((jobPost) =>
        jobRoles.some((role) => jobPost.job_role_id === role.id)
      );
    }

    if (jobSettings.length > 0) {
      filtered = filtered.filter((jobPost) =>
        jobSettings.some((setting) => jobPost.job_setting_id === setting.id)
      );
    }

    if (jobCommitments.length > 0) {
      filtered = filtered.filter((jobPost) =>
        jobCommitments.some(
          (commitment) => jobPost.job_commitment_id === commitment.id
        )
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
    setSelectedCompanies([]);
    setSelectedSpecialties([]);
    setSelectedDomains([]);
    setSelectedDepartments([]);
    setSelectedJobRoles([]);
    setSelectedJobSettings([]);
    setSelectedJobCommitments([]);
    setFilteredJobPosts(jobPosts);
  };

  const getNoResultsMessage = () => {
    const filters = [];

    if (selectedCompanies.length > 0) {
      filters.push(
        `for companies ${selectedCompanies.map((c) => c.company_name).join(', ')}`
      );
    }

    if (selectedSpecialties.length > 0) {
      filters.push(
        `with specialties ${selectedSpecialties.map((s) => s.value).join(', ')}`
      );
    }

    if (selectedDomains.length > 0) {
      filters.push(
        `in domains ${selectedDomains.map((d) => d.value).join(', ')}`
      );
    }

    if (selectedDepartments.length > 0) {
      filters.push(
        `in departments ${selectedDepartments.map((d) => d.dept_name).join(', ')}`
      );
    }

    if (selectedJobRoles.length > 0) {
      filters.push(
        `for job roles ${selectedJobRoles.map((r) => r.role_name).join(', ')}`
      );
    }

    if (selectedJobSettings.length > 0) {
      filters.push(
        `for job settings ${selectedJobSettings.map((s) => s.setting_name).join(', ')}`
      );
    }

    if (selectedJobCommitments.length > 0) {
      filters.push(
        `for job commitments ${selectedJobCommitments.map((c) => c.commitment_name).join(', ')}`
      );
    }

    let message = 'No matching job posts';

    if (filters.length > 0) {
      message += ` ${filters.join(', ')}.`;
    }

    return message;
  };

  /* --------------------- Effect to filter job posts --------------------- */

  useEffect(() => {
    filterJobPosts(
      selectedCompanies,
      selectedSpecialties,
      selectedDomains,
      selectedDepartments,
      selectedJobRoles,
      selectedJobSettings,
      selectedJobCommitments
    );
  }, [
    selectedCompanies,
    selectedSpecialties,
    selectedDomains,
    selectedDepartments,
    selectedJobRoles,
    selectedJobSettings,
    selectedJobCommitments,
  ]);

  return {
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
  };
};
