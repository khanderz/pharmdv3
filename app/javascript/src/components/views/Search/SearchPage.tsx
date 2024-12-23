import React from "react";
import { Box, Grid, Pagination, Typography } from "@mui/material";
import { FilterPanel } from "@components/organisms/FilterPanel/FilterPanel";
import { JobCard } from "@components/organisms/JobCard/JobCard";
import {
  JobCommitment,
  JobSalaryInterval,
  JobSetting,
  JobSalaryCurrency,
} from "@customtypes/job_post";
import {
  LoadingState,
  ErrorState,
  NoMatchState,
} from "@components/views/index";
import { Container } from "@components/atoms/Paper";
import { useSearchPageLogic } from "./SearchPage.logic";
import moment from "moment";

export const SearchPage = () => {
  const {
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
    onSortByDate,
  } = useSearchPageLogic();

  return (
    <Container
      dataTestId="search"
      sx={{
        flexDirection: "column",
        justifyContent: "flex-start",
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
                resetFilters={resetAndHandlePageChange}
                onSortByDate={onSortByDate}
              />
            </Grid>

            <Grid item xs={12} data-testid="job-post-grid">
              {noMatchingResults && getNoResultsMessage ? (
                <NoMatchState
                  message={getNoResultsMessage()}
                  onReset={resetAndHandlePageChange}
                />
              ) : (
                <>
                  <Grid container spacing={3} data-testid="job-cards-container">
                    {paginatedJobPosts.map(jobPost => {
                      console.log(jobPost);
                      const jobCommitmentType = jobCommitments.find(
                        commitment =>
                          commitment.id === jobPost.job_commitment_id,
                      );

                      const jobSetting = jobSettings.find(
                        setting => setting.id === jobPost.job_setting_id,
                      );

                      const domains = jobPost.company.company_domains.map(
                        domain => domain.healthcare_domain["value"],
                      );

                      const locations = Array.isArray(jobPost.job_locations)
                        ? jobPost.job_locations.map(location => location)
                        : [jobPost.job_locations];

                      return (
                        <Grid item xs={12} key={jobPost.id}>
                          <JobCard
                            title={jobPost.job_title}
                            company_name={jobPost.company.company_name}
                            job_applyUrl={jobPost.job_url}
                            job_posted={jobPost.job_posted}
                            job_location={locations}
                            job_setting={
                              jobSetting?.setting_name as JobSetting["setting_name"]
                            }
                            job_commitment={
                              jobCommitmentType?.commitment_name as JobCommitment["commitment_name"]
                            }
                            healthcare_domains={domains}
                            updatedDate={moment(jobPost.updated_at).format(
                              "MMMM Do, YYYY [at] h:mm A",
                            )}
                          />
                        </Grid>
                      );
                    })}
                  </Grid>

                  <Box
                    sx={{ my: 4, display: "flex", justifyContent: "center" }}
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
