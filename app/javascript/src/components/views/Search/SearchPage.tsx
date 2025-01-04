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
    jobCommitments,
    noMatchingResults,
    getNoResultsMessage,
    onSortByDate,

    departments,
    benefits,
    credentials,
    educations,
    experiences,
    currencies,
    uniqueLocations,
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
                      const jobCommitmentType = jobPost.job_commitment_id
                        ? jobCommitments.find(
                            commitment =>
                              commitment.id === jobPost.job_commitment_id,
                          )
                        : null;

                      const domains = jobPost.company.company_domains.map(
                        domain => domain.healthcare_domain["value"],
                      );

                      const department = departments.find(
                        department => department.id === jobPost.department_id,
                      )?.dept_name;

                      const job_benefits = jobPost.job_post_benefits?.map(
                        job_post_benefit =>
                          benefits.find(
                            benefit =>
                              benefit.id === job_post_benefit.benefit_id,
                          ).benefit_name,
                      );

                      const job_credentials = jobPost.job_post_credentials?.map(
                        job_post_credential =>
                          credentials.find(
                            credential =>
                              credential.id ===
                              job_post_credential.credential_id,
                          ).credential_name,
                      );

                      const job_educations = jobPost.job_post_educations?.map(
                        job_post_education =>
                          educations.find(
                            education =>
                              education.id === job_post_education.education_id,
                          ).education_name,
                      );

                      const job_experiences = jobPost.job_post_experiences?.map(
                        job_post_experience =>
                          experiences.find(
                            experience =>
                              experience.id ===
                              job_post_experience.experience_id,
                          ).experience_name,
                      );

                      const job_currencies = currencies.find(
                        currency =>
                          currency.id === jobPost.job_salary_currency_id,
                      )?.currency_code;

                      const job_post_locations = jobPost.job_post_locations
                        ?.map(
                          job_post_location =>
                            uniqueLocations?.find(
                              loc => loc.id === job_post_location.location_id,
                            ).name,
                        )
                        .reverse();

                      return (
                        <Grid item xs={12} key={jobPost.id}>
                          <JobCard
                            title={jobPost.job_title}
                            company_name={jobPost.company.company_name}
                            job_applyUrl={jobPost.job_url}
                            job_posted={jobPost.job_posted}
                            job_setting={jobPost.job_setting}
                            job_commitment={
                              jobCommitmentType?.commitment_name as JobCommitment["commitment_name"]
                            }
                            healthcare_domains={domains}
                            updatedDate={moment(jobPost.updated_at).format(
                              "MMMM Do, YYYY [at] h:mm A",
                            )}
                            job_locations={job_post_locations}
                            department={department}
                            job_description={jobPost.job_description}
                            job_benefits={job_benefits}
                            job_credentials={job_credentials}
                            job_educations={job_educations}
                            job_experiences={job_experiences}
                            job_qualifications={jobPost.job_qualifications}
                            job_responsibilities={jobPost.job_responsibilities}
                            job_currency={job_currencies}
                            job_salary_max={jobPost.job_salary_max}
                            job_salary_min={jobPost.job_salary_min}
                            job_salary_single={jobPost.job_salary_single}
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
