import React, { useEffect, useState } from "react";
import { Typography } from "@mui/material";
import { LicenseInfo } from "@mui/x-license-pro";
import { Container, Grid, Pagination } from "@mui/material";
import { DirectoryTable } from "./DirectoryTable";
import { FilterPanel } from "@components/organisms/FilterPanel/FilterPanel";
import { useApiKey } from "@hooks";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";
import {
  LoadingState,
  ErrorState,
  NoMatchState,
} from "@components/views/index";

const COMPANIES_PER_PAGE = 10;

export const Directory = () => {
  /* --------------------- MUI-X --------------------- */

  const { key } = useApiKey();

  useEffect(() => {
    if (key) {
      LicenseInfo.setLicenseKey(key);
    }
  }, [key]);

  /* --------------------- Hooks --------------------- */
  const {
    filteredCompanies,
    errors,
    currentlyLoading,
    noMatchingResults,
    getNoResultsMessage,
    resetFilters,
  } = useFiltersContext();

  const [currentPage, setCurrentPage] = useState(1);

  /* --------------------- Constants --------------------- */
  const totalPages = Math.ceil(filteredCompanies.length / COMPANIES_PER_PAGE);

  const paginatedCompanies = filteredCompanies.slice(
    (currentPage - 1) * COMPANIES_PER_PAGE,
    currentPage * COMPANIES_PER_PAGE,
  );

  /* --------------------- Handles --------------------- */

  const handlePageChange = (
    event: React.ChangeEvent<unknown>,
    page: number,
  ) => {
    setCurrentPage(page);
  };

  const resetAndHandlePageChange = () => {
    resetFilters();
    setCurrentPage(1);
  };

  if (currentlyLoading) {
    return <LoadingState />;
  }

  if (errors) {
    return <ErrorState message={errors} />;
  }

  if (noMatchingResults) {
    return <NoMatchState message={getNoResultsMessage()} />;
  }

  return (
    <Container dataTestId="directory">
      <Grid container spacing={4} data-testid="search-page-container">
        <Grid item xs={12} data-testid="filter-panel-grid">
          <FilterPanel resetFilters={resetAndHandlePageChange} />
        </Grid>
        <Grid item xs={12} data-testid="companies-grid-item">
          {paginatedCompanies?.length === 0 ? (
            <Typography>No companies found.</Typography>
          ) : (
            <DirectoryTable
              data={paginatedCompanies}
              rows={filteredCompanies?.length}
            />
          )}
        </Grid>
        {totalPages > 1 && (
          <Grid item xs={12} data-testid="pagination-grid">
            <Pagination
              count={totalPages}
              page={currentPage}
              onChange={handlePageChange}
              color="primary"
            />
          </Grid>
        )}
      </Grid>
    </Container>
  );
};
