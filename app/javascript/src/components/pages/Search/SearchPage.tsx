import React, { useState, useEffect } from 'react';
import { Box, Container, Grid, Pagination } from '@mui/material';
import { JobPost } from '../../../types/job_post.types';
import { FilterPanel } from '../../molecules/FilterPanel/FilterPanel';
import { SearchPanel } from '../../molecules/SearchPanel/SearchPanel';
import { JobCard } from '../../organisms/JobCard/JobCard';

export const SearchPage = () => {
  const [jobPosts, setJobPosts] = useState<JobPost[]>([]);

  // Fetch job posts data
  useEffect(() => {
    const fetchJobPosts = async () => {
      try {
        const response = await fetch('/job_posts.json');
        const data = await response.json();
        setJobPosts(data);
      } catch (error) {
        console.error('Error fetching job posts:', error);
      }
    };

    fetchJobPosts();
  }, []);

  console.log(jobPosts);

  return (
    <Container maxWidth="lg">
      <SearchPanel />

      <Grid container spacing={4}>
        <Grid item xs={12} md={3}>
          <FilterPanel />
        </Grid>

        <Grid item xs={12} md={9}>
          <Grid container spacing={3}>
            {jobPosts.map((jobPost) => (
              <Grid item xs={12} key={jobPost.id}>
                <JobCard
                  title={jobPost.job_title}
                  company_name={jobPost.company.company_name}
                  job_location={jobPost.job_location}
                  job_commitment={jobPost.job_commitment}
                  job_applyUrl={jobPost.job_applyUrl}
                />
              </Grid>
            ))}
          </Grid>

          {/* Pagination */}
          <Box sx={{ mt: 4, display: 'flex', justifyContent: 'center' }}>
            <Pagination count={10} color="primary" />
          </Box>
        </Grid>
      </Grid>
    </Container>
  );
};
