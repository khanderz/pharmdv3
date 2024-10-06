import React, { useState, useEffect } from 'react';
import { Box, Container, Grid, TextField, Card, CardContent, Typography, Button, Pagination } from '@mui/material';
import { JobPost } from '../../../types/job_post.types';
import { FilterPanel } from '../../molecules/FilterPanel/FilterPanel';
import { SearchPanel } from '../../molecules/SearchPanel/SearchPanel';

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
    <FilterPanel />

        {/* Job Listings */}
        <Grid item xs={12} md={9}>
          <Grid container spacing={3}>
            {jobPosts.map((jobPost) => (
              <Grid item xs={12} key={jobPost.id}>
                <Card variant="outlined" sx={{ p: 2 }}>
                  <CardContent>
                    <Typography variant="h6">{jobPost.job_title}</Typography>
                    <Typography variant="body2" color="text.secondary">
                      {jobPost.company?.company_name || "Unknown Company"}
                    </Typography>
                    <Typography variant="body2" sx={{ mt: 1 }}>
                      Location: {jobPost.job_location || "N/A"}
                    </Typography>
                    <Typography variant="body2" sx={{ mt: 1 }}>
                      Job Type: {jobPost.job_commitment || "N/A"} / {jobPost.job_setting || "N/A"}
                    </Typography>
                    <Button variant="contained" color="primary" sx={{ mt: 2 }} href={jobPost.job_applyUrl}>
                      Apply Now
                    </Button>
                  </CardContent>
                </Card>
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
