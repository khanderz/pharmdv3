import React, { useState, useEffect } from 'react';
import { Box, Container, Grid, Pagination, Typography } from '@mui/material';
import { JobPost } from '../../../types/job_post/job_post.types';
import { FilterPanel } from '../../organisms/FilterPanel/FilterPanel';
import { SearchPanel } from '../../molecules/SearchPanel/SearchPanel';
import { JobCard } from '../../organisms/JobCard/JobCard';
import { Company, CompanySpecialty, HealthcareDomain } from '../../../types/company';
import { Department, Team } from '../../../types/job_role';

export const SearchPage = () => {
  const [jobPosts, setJobPosts] = useState<JobPost[]>([]);
  const [filteredJobPosts, setFilteredJobPosts] = useState<JobPost[]>([]);
  const [selectedCompany, setSelectedCompany] = useState<Company['company_name'] | null>(null);
  const [selectedSpecialty, setSelectedSpecialty] = useState<CompanySpecialty['value'] | null>(null);
  const [selectedDomain, setSelectedDomain] = useState<HealthcareDomain['value'] | null>(null);
  const [selectedDepartment, setSelectedDepartment] = useState<Department['dept_name'] | null>(null);
  const [selectedTeam, setSelectedTeam] = useState<Team['team_name'] | null>(null);

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
  const uniqueSpecialties: CompanySpecialty[] = Array.from(
    new Set(
      jobPosts.flatMap((jobPost) =>
        jobPost.company.company_specialties ?? []
      )
    )
  ).filter(Boolean);

  // Extract unique healthcare domains from job posts
  const uniqueDomains: HealthcareDomain[] = Array.from(
    new Set(
      jobPosts.flatMap((jobPost) =>
        jobPost.company.healthcare_domains ?? []
      )
    )
  ).filter(Boolean);

  const uniqueDepartments: any = Array.from(new Set(jobPosts.map((jobPost) => jobPost.job_dept))).filter(Boolean);
  const uniqueTeams: any = Array.from(new Set(jobPosts.map((jobPost) => jobPost.job_team))).filter(Boolean);

  // Handle filtering based on the selected company
  const handleCompanyFilter = (companyName: Company['company_name'] | null) => {
    setSelectedCompany(companyName);
    filterJobPosts(companyName, selectedSpecialty, selectedDomain);
  };

  // Handle filtering based on the selected specialty
  const handleSpecialtyFilter = (specialty: CompanySpecialty['value'] | null) => {
    setSelectedSpecialty(specialty);
    filterJobPosts(selectedCompany, specialty, selectedDomain);
  };

  // Handle filtering based on the selected healthcare domain
  const handleDomainFilter = (domain: HealthcareDomain['value'] | null) => {
    setSelectedDomain(domain);
    filterJobPosts(selectedCompany, selectedSpecialty, domain);
  };

  const handleDepartmentFilter = (department: any | null) => {
    setSelectedDepartment(department);
    filterJobPosts(selectedCompany, selectedSpecialty, selectedDomain, department, selectedTeam);
  };

  const handleTeamFilter = (team: any | null) => {
    setSelectedTeam(team);
    filterJobPosts(selectedCompany, selectedSpecialty, selectedDomain, selectedDepartment, team);
  };

  // Filter job posts based on selected filters
  const filterJobPosts = (
    companyName: Company['company_name'] | null,
    specialty: CompanySpecialty['value'] | null,
    domain: HealthcareDomain['value'] | null,
    department: Department['dept_name'] | null = null,
    team: Team['team_name'] | null = null
  ) => {
    let filtered = jobPosts;

    if (companyName) {
      filtered = filtered.filter((jobPost) => jobPost.company.company_name === companyName);
    }

    if (specialty) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.company_specialties?.some((spec: CompanySpecialty) => spec.value === specialty)
      );
    }

    if (domain) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.healthcare_domains?.some((dom: HealthcareDomain) => dom.value === domain)
      );
    }

    if (department) {
      filtered = filtered.filter((jobPost) => jobPost.job_dept.dept_name === department);
    }

    if (team) {
      filtered = filtered.filter((jobPost) => jobPost.job_team.team_name === team);
    }

    setFilteredJobPosts(filtered);
  };

  return (
    <Container maxWidth="lg">
      <Box justifyContent='center' display='flex' sx={{ margin: 2 }} data-testid="search-page-title" >
        <Typography variant="title" >
          Search for a job post
        </Typography>
      </Box>
      <SearchPanel />

      <Grid container spacing={4} data-testid="search-page-container" >
        <Grid item xs={12} md={3} data-testid="filter-panel-grid">
          <FilterPanel
            companies={uniqueCompanies}
            selectedCompany={selectedCompany}
            onCompanyFilter={handleCompanyFilter}
            specialties={uniqueSpecialties}
            selectedSpecialty={selectedSpecialty}
            onSpecialtyFilter={handleSpecialtyFilter}
            domains={uniqueDomains}
            selectedDomain={selectedDomain}
            onDomainFilter={handleDomainFilter}
            departments={uniqueDepartments}
            selectedDepartment={selectedDepartment}
            onDepartmentFilter={handleDepartmentFilter}
            teams={uniqueTeams}
            selectedTeam={selectedTeam}
            onTeamFilter={handleTeamFilter}
          />
        </Grid>

        <Grid item xs={12} md={9} data-testid="job-post-grid">
          <Grid container spacing={3} data-testid="job-cards-container">
            {filteredJobPosts.map((jobPost) => (
              <Grid item xs={12} key={jobPost.id}>
                <JobCard
                  title={jobPost.job_title}
                  company_name={jobPost.company.company_name}
                  // job_location={jobPost.job_location}
                  // job_commitment={jobPost.job_commitment}
                  job_applyUrl={jobPost.job_applyUrl}
                  company_specialty={jobPost.company.company_specialties[0]?.value}
                // healthcare_domain={jobPost.company.healthcare_domains[0]?.value}
                />
              </Grid>
            ))}
          </Grid>

          <Box sx={{ mt: 4, display: 'flex', justifyContent: 'center' }} data-testid="pagination-box">
            <Pagination count={10} color="primary" />
          </Box>
        </Grid>
      </Grid>
    </Container>
  );
};
