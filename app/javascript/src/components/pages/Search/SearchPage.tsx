import React, { useState, useEffect } from 'react';
import { Box, Container, Grid, Pagination } from '@mui/material';
import { JobPost } from '../../../types/job_post.types';
import { FilterPanel } from '../../organisms/FilterPanel/FilterPanel';
import { SearchPanel } from '../../molecules/SearchPanel/SearchPanel';
import { JobCard } from '../../organisms/JobCard/JobCard';

export const SearchPage = () => {
  const [jobPosts, setJobPosts] = useState<JobPost[]>([]);
  const [filteredJobPosts, setFilteredJobPosts] = useState<JobPost[]>([]);
  const [selectedCompany, setSelectedCompany] = useState<Company['company_name'] | null>(null);

  // Fetch job posts data
  useEffect(() => {
    const fetchJobPosts = async () => {
      try {
        const response = await fetch('/job_posts.json');
        const data = await response.json();
        setJobPosts(data);
        setFilteredJobPosts(data); // Initially show all job posts
      } catch (error) {
        console.error('Error fetching job posts:', error);
      }
    };

    fetchJobPosts();
  }, []);

  // Extract unique companies with job posts
  const uniqueCompanies: Company['company_name'][] = Array.from(
    new Set(jobPosts.map((jobPost) => jobPost.company.company_name))
  );

  // Handle filtering based on the selected company
  const handleCompanyFilter = (companyName: Company['company_name'] | null) => {
    setSelectedCompany(companyName);
    if (companyName) {
      const filtered = jobPosts.filter((jobPost) => jobPost.company.company_name === companyName);
      setFilteredJobPosts(filtered);
    } else {
      setFilteredJobPosts(jobPosts); // Show all posts if no company is selected
    }
  };

  console.log({ jobPosts, uniqueCompanies })
  return (
    <Container maxWidth="lg">
      <SearchPanel />

      <Grid container spacing={4}>
        <Grid item xs={12} md={3}>
          <FilterPanel
            companies={uniqueCompanies}
            selectedCompany={selectedCompany}
            onCompanyFilter={handleCompanyFilter}
          />
        </Grid>

        <Grid item xs={12} md={9}>
          <Grid container spacing={3}>
            {filteredJobPosts.map((jobPost) => (
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
