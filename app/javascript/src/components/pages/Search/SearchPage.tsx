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
  const [selectedDepartment, setSelectedDepartment] = useState<JobPost['job_dept'] | null>(null);
  const [selectedTeam, setSelectedTeam] = useState<JobPost['job_team'] | null>(null);

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

  const uniqueDepartments: JobPost['job_dept'][] = Array.from(new Set(jobPosts.map((jobPost) => jobPost.job_dept))).filter(Boolean);
  const uniqueTeams: JobPost['job_team'][] = Array.from(new Set(jobPosts.map((jobPost) => jobPost.job_team))).filter(Boolean);


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

  const handleDepartmentFilter = (department: JobPost['job_dept'] | null) => {
    setSelectedDepartment(department);
    filterJobPosts(selectedCompany, selectedSpecialty, department, selectedTeam);
  };

  const handleTeamFilter = (team: JobPost['job_team'] | null) => {
    setSelectedTeam(team);
    filterJobPosts(selectedCompany, selectedSpecialty, selectedDepartment, team);
  };

  // Filter job posts based on selected company, specialty, department, and team
  const filterJobPosts = (companyName: Company['company_name'] | null, specialty: CompanySpecialty['value'] | null, department: JobPost['job_dept'] | null, team: JobPost['job_team'] | null) => {
    let filtered = jobPosts;

    if (companyName) {
      filtered = filtered.filter((jobPost) => jobPost.company.company_name === companyName);
    }

    if (specialty) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.company_specialties?.some((spec: CompanySpecialty) => spec.value === specialty)
      );
    }

    if (department) {
      filtered = filtered.filter((jobPost) => jobPost.job_dept === department);
    }

    if (team) {
      filtered = filtered.filter((jobPost) => jobPost.job_team === team);
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
            specialties={uniqueSpecialties}
            selectedSpecialty={selectedSpecialty}
            onSpecialtyFilter={handleSpecialtyFilter}
            departments={uniqueDepartments}
            selectedDepartment={selectedDepartment}
            onDepartmentFilter={handleDepartmentFilter}
            teams={uniqueTeams}
            selectedTeam={selectedTeam}
            onTeamFilter={handleTeamFilter}
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
                  // @ts-ignore - fix later
                  company_specialty={jobPost.company.company_specialties[0]?.value}
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
