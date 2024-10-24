import React, { useState } from 'react';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';

const POSTS_PER_PAGE = 10;

export const useSearchPageLogic = () => {
  /* --------------------- Hooks --------------------- */
  const {
    errors,
    currentlyLoading,
    jobSettings,
    jobCommitments,
    noMatchingResults,
    getNoResultsMessage,
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

  const resetAndHandlePageChange = () => {
    resetFilters();
    setCurrentPage(1);
  };

  return {
    resetAndHandlePageChange,
    paginatedJobPosts,
    totalPages,
    currentPage,
    handlePageChange,
    errors,
    currentlyLoading,
    jobSettings,
    jobCommitments,
    noMatchingResults,
    getNoResultsMessage,
    filteredJobPosts,
    resetFilters,
  };
};
