import React, { useState, useEffect } from 'react';
import { Box, Container, Grid, Pagination } from '@mui/material';
import { JobPost } from '../../../types/job_post.types';
import { FilterPanel } from '../../organisms/FilterPanel/FilterPanel';
import { SearchPanel } from '../../molecules/SearchPanel/SearchPanel';
import { JobCard } from '../../organisms/JobCard/JobCard';
import { Company, CompanySpecialty } from '../../../types/company.types';

export const SearchPage = () => {
  const [jobPosts, setJobPosts] = useState<JobPost[]>([]);
  const [filteredJobPosts, setFilteredJobPosts] = useState<JobPost[]>([]);
  const [selectedCompany, setSelectedCompany] = useState<Company['company_name'] | null>(null);
  const [selectedSpecialty, setSelectedSpecialty] = useState<CompanySpecialty['value'] | null>(null);

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

  // Extract unique specialties from job posts
  const uniqueSpecialties: CompanySpecialty['value'][] = Array.from(
    new Set(jobPosts.flatMap((jobPost) => jobPost.company.company_specialties?.map((spec) => spec.value)))
  ).filter(Boolean);

  // Handle filtering based on the selected company
  const handleCompanyFilter = (companyName: Company['company_name'] | null) => {
    setSelectedCompany(companyName);
    filterJobPosts(companyName, selectedSpecialty);
  };

  // Handle filtering based on the selected specialty
  const handleSpecialtyFilter = (specialty: CompanySpecialty['value'] | null) => {
    setSelectedSpecialty(specialty);
    filterJobPosts(selectedCompany, specialty);
  };

  // Filter job posts based on selected company and specialty
  const filterJobPosts = (companyName: Company['company_name'] | null, specialty: CompanySpecialty['value'] | null) => {
    let filtered = jobPosts;

    if (companyName) {
      filtered = filtered.filter((jobPost) => jobPost.company.company_name === companyName);
    }

    if (specialty) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.company_specialties?.some((spec: CompanySpecialty) => spec.value === specialty)
      );
    }

    setFilteredJobPosts(filtered);
  };

  return (
    <Container maxWidth="lg">
      <SearchPanel />

      <Grid container spacing={4}>
        <Grid item xs={12} md={3}>
          <FilterPanel
            companies={uniqueCompanies}
            selectedCompany={selectedCompany}
            onCompanyFilter={handleCompanyFilter}
            specialties={uniqueSpecialties}  // Pass specialties to FilterPanel
            selectedSpecialty={selectedSpecialty}  // Pass selected specialty
            onSpecialtyFilter={handleSpecialtyFilter}  // Pass the filter handler
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
                  // @ts-ignore
                  company_specialty={jobPost.company.company_specialties[0]?.value}  // Adjusted
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
