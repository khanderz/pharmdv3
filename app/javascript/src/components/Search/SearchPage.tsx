import React, { useState, useEffect } from 'react';
import { Box, Container, Grid, TextField, Card, CardContent, Typography, Button, Pagination } from '@mui/material';
import { Company } from '../../types/company.types';
import { JobPost } from '../../types/job_post.types';


export const SearchPage = () => {
  const [companies, setCompanies] = useState<Company[]>([]);
  const [jobPosts, setJobPosts] = useState<JobPost[]>([]);

  // Fetch companies data
  useEffect(() => {
    const fetchCompanies = async () => {
      try {
        const response = await fetch('/companies.json');
        const data = await response.json();
        setCompanies(data);
      } catch (error) {
        console.error("Error fetching companies:", error);
      }
    };

    fetchCompanies();
  }, []);

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

  console.log({ companies, jobPosts });

  return (
    <Container maxWidth="lg">
      {/* Search Bar */}
      <Box sx={{ mt: 4, mb: 4 }}>
        <TextField
          fullWidth
          variant="outlined"
          placeholder="Search for jobs or companies..."
        />
      </Box>

      <Grid container spacing={4}>
        {/* Filters Panel */}
        <Grid item xs={12} md={3}>
          <Box sx={{ border: '1px solid #e0e0e0', borderRadius: '8px', p: 2 }}>
            <Typography variant="h6">Filters</Typography>
            {/* Placeholder filter buttons */}
            <Box sx={{ mt: 2 }}>
              <Typography variant="body1">Location</Typography>
              <Button variant="outlined" fullWidth sx={{ my: 1 }}>United States</Button>
            </Box>
            <Box sx={{ mt: 2 }}>
              <Typography variant="body1">Job Type</Typography>
              <Button variant="outlined" fullWidth sx={{ my: 1 }}>Full-time</Button>
              <Button variant="outlined" fullWidth sx={{ my: 1 }}>Part-time</Button>
            </Box>
            <Box sx={{ mt: 2 }}>
              <Typography variant="body1">Remote</Typography>
              <Button variant="outlined" fullWidth sx={{ my: 1 }}>Remote</Button>
            </Box>
          </Box>
        </Grid>

        {/* Job Listings */}
        <Grid item xs={12} md={9}>
          <Grid container spacing={3}>
            {jobPosts.map((jobPost, index) => (
              <Grid item xs={12} key={jobPost.id || index}>
                <Card variant="outlined" sx={{ p: 2 }}>
                  <CardContent>
                    <Typography variant="h6">{jobPost.job_title}</Typography>
                    <Typography variant="body2" color="text.secondary">
                      {companies.find(company => company.id === jobPost.companies_id)?.company_name || "Unknown Company"}
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
