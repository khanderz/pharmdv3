import React, { useState } from 'react';
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
        jobPost.company.company_domains?.some((dom) => dom.id === domain)
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
      filters.push(`for job setting "${selectedJobSetting.setting_name}"`);
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

  return {
    errors,
    currentlyLoading,
    uniqueCompanies,
    selectedCompany,
    handleCompanyFilter,
    uniqueSpecialties,
    selectedSpecialty,
    handleSpecialtyFilter,
    allDomains,
    selectedDomain,
    handleDomainFilter,
    departments,
    selectedDepartment,
    handleDepartmentFilter,
    uniqueJobRoles,
    selectedJobRole,
    handleJobRoleFilter,
    jobSettings,
    selectedJobSetting,
    handleJobSettingFilter,
    jobCommitments,
    selectedJobCommitment,
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
