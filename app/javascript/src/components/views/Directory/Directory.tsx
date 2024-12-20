import React, { useEffect, useState } from "react";
import { Typography } from "@mui/material";
import { LicenseInfo } from "@mui/x-license-pro";
import { Container, Grid } from "@mui/material";
import { DirectoryTable } from "./DirectoryTable";
import { FilterPanel } from "@components/organisms/FilterPanel/FilterPanel";
import { useApiKey } from "@hooks/get_api_var";
import { useCompanies } from "@hooks/get_companies";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";

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
    errors,
    currentlyLoading,
    noMatchingResults,
    getNoResultsMessage,
    resetFilters,
  } = useFiltersContext();

  const { companies, loading, error } = useCompanies();
  const [currentPage, setCurrentPage] = useState(1);

  /* --------------------- Constants --------------------- */
  const totalPages = Math.ceil(filteredJobPosts.length / POSTS_PER_PAGE);

  const paginatedJobPosts = filteredJobPosts.slice(
    (currentPage - 1) * POSTS_PER_PAGE,
    currentPage * POSTS_PER_PAGE,
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

  // console.log({ companies });
  // useEffect(() => {
  //   setCompanies(companiesData);
  //   setLoading(loadingReturn);
  //   setError(errorReturn);
  // }, [companiesData, loadingReturn, errorReturn]);

  if (loading) {
    return <Typography>Loading...</Typography>;
  }

  if (error) {
    return <Typography>Error: {error.message}</Typography>;
  }

  return (
    <Container dataTestId="directory">
      {/* <Box
        sx={{
          justifySelf: 'flex-start',
          alignSelf: 'flex-start',
          width: '100%',
          mt: 2,
        }}
      >
        {companies?.length === 0 ? (
          <Typography>No companies found.</Typography>
        ) : (
          <DirectoryTable data={companies} rows={companies?.length} />
        )}
      </Box> */}

      <Grid container spacing={4} data-testid="search-page-container">
        <Grid item xs={12} data-testid="filter-panel-grid">
          <FilterPanel
            resetFilters={resetAndHandlePageChange}
            onSortByDate={onSortByDate}
          />
        </Grid>
        <Grid item xs={12} data-testid="companies-grid-item">
          {companies?.length === 0 ? (
            <Typography>No companies found.</Typography>
          ) : (
            <DirectoryTable data={companies} rows={companies?.length} />
          )}
        </Grid>
      </Grid>
    </Container>
  );
};
