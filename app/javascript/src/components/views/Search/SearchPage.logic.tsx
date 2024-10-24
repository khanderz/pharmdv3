import React, { useState } from 'react';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';

const POSTS_PER_PAGE = 10;

export const useSearchPageLogic = () => {
  /* --------------------- Hooks --------------------- */
  const {
    selectedCompanies,
    setSelectedCompanies,
    selectedDomains,
    setSelectedDomains,
    selectedSpecialties,
    setSelectedSpecialties,
    selectedDepartments,
    setSelectedDepartments,
    selectedJobRoles,
    setSelectedJobRoles,
    selectedJobSettings,
    setSelectedJobSettings,
    selectedJobCommitments,
    setSelectedJobCommitments,
    errors,
    currentlyLoading,
    uniqueCompanies,
    uniqueSpecialties,
    allDomains,
    departments,
    uniqueJobRoles,
    jobSettings,
    jobCommitments,
    filteredJobPosts,
    resetFilters,
  } = useFiltersContext();

  /* --------------------- States --------------------- */

  const [currentPage, setCurrentPage] = useState(1);

  /* --------------------- Constants --------------------- */
  const totalPages = Math.ceil(filteredJobPosts.length / POSTS_PER_PAGE);

  const paginatedJobPosts = filteredJobPosts.slice(
    (currentPage - 1) * POSTS_PER_PAGE,
    currentPage * POSTS_PER_PAGE
  );

  /* --------------------- Handles --------------------- */

  const handlePageChange = (
    event: React.ChangeEvent<unknown>,
    page: number
  ) => {
    setCurrentPage(page);
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

  return {
    errors,
    currentlyLoading,
    uniqueCompanies,
    selectedCompanies,
    handleCompanyFilter: setSelectedCompanies,
    uniqueSpecialties,
    selectedSpecialties,
    handleSpecialtyFilter: setSelectedSpecialties,
    allDomains,
    selectedDomains,
    handleDomainFilter: setSelectedDomains,
    departments,
    selectedDepartments,
    handleDepartmentFilter: setSelectedDepartments,
    uniqueJobRoles,
    selectedJobRoles,
    handleJobRoleFilter: setSelectedJobRoles,
    jobSettings,
    selectedJobSettings,
    handleJobSettingFilter: setSelectedJobSettings,
    jobCommitments,
    selectedJobCommitments,
    handleJobCommitmentFilter: setSelectedJobCommitments,
    noMatchingResults: filteredJobPosts.length === 0,
    resetFilters,
    paginatedJobPosts,
    totalPages,
    currentPage,
    handlePageChange,
    getNoResultsMessage,
  };
};
