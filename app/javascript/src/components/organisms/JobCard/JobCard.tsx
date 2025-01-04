import React from "react";
import { Card, CardContent, Typography, Box } from "@mui/material";
import { Company, HealthcareDomain } from "@customtypes/company";
import { JobCommitment, JobPost } from "@customtypes/job_post";
import { Button } from "@components/atoms/Button";
import { Attribute } from "@javascript/components/atoms/Attribute";
import { Department } from "@javascript/types/job_role";

interface JobCardProps {
  title: JobPost["job_title"];
  company_name: Company["company_name"];
  job_setting: JobPost["job_setting"];
  job_commitment: JobCommitment["commitment_name"];
  job_applyUrl: JobPost["job_applyUrl"];
  healthcare_domains: HealthcareDomain["value"][];

  job_posted: JobPost["job_posted"];
  updatedDate: JobPost["updated_at"];

  department?: Department["department_name"];
  job_description?: JobPost["job_description"];
  job_benefits?: JobPost["job_benefits"];
  job_credentials?: JobPost["job_credentials"];
  job_educations?: JobPost["job_educations"];
  job_experiences?: JobPost["job_experiences"];
  job_locations?: JobPost["job_locations"];
  job_qualifications?: JobPost["job_qualifications"];
  job_responsibilities?: JobPost["job_responsibilities"];
  job_currency?: any;
  job_salary_interval?: any;
  job_salary_max?: JobPost["job_salary_max"];
  job_salary_min?: JobPost["job_salary_min"];
  job_salary_single?: JobPost["job_salary_single"];
}

export const JobCard = ({
  title,
  company_name,
  job_applyUrl,
  job_posted,
  job_setting,
  job_commitment,
  healthcare_domains,
  updatedDate,

  department,
  job_description,
  job_benefits,
  job_credentials,
  job_educations,
  job_experiences,
  job_locations,
  job_qualifications,
  job_responsibilities,
  job_currency,
  job_salary_interval,
  job_salary_max,
  job_salary_min,
  job_salary_single,
}: JobCardProps) => {
  ("");
  const jobPostDate = job_posted
    ? new Date(job_posted).toLocaleDateString()
    : "";

  const domainsLabel =
    healthcare_domains && healthcare_domains.length > 1
      ? "Healthcare Domains"
      : "Healthcare Domain";

  const salary_range =
    job_salary_min && job_salary_max
      ? `${job_salary_min} - ${job_salary_max}`
      : job_salary_single;

  return (
    <Card
      variant="outlined"
      sx={{
        p: 2,
        border: "1px solid #226f54",
        borderRadius: "2px",
      }}
      data-testid="job-card"
    >
      <CardContent>
        <Typography variant="h6">{title}</Typography>
        <Typography
          variant="body2"
          color="text.secondary"
          sx={{
            mb: 1,
          }}
        >
          {company_name || "Unknown Company"}
        </Typography>
        <Attribute label={domainsLabel} value={healthcare_domains} renderChip />
        {job_setting.length != 0 && (
          <Attribute label="Setting" value={job_setting} />
        )}
        {job_locations.length != 0 && (
          <Attribute label="Location" value={job_locations || "N/A"} />
        )}
        <Attribute label="Department" value={department} />

        {/* {job_credentials.length != 0 && (
          <Attribute label="Credentials" value={job_credentials} />
        )} */}

        {job_educations.length != 0 && (
          <Attribute label="Education" value={job_educations} />
        )}

        {job_experiences.length != 0 && (
          <Attribute label="Experience" value={job_experiences} />
        )}

        {salary_range && <Attribute label="Salary" value={salary_range} />}

        {job_salary_single && (
          <Attribute label="Salary" value={job_salary_single} />
        )}

        <Box
          mt={2}
          textAlign="center"
          sx={{
            float: "left",
          }}
        >
          <Attribute
            label="Posted Date"
            value={jobPostDate || "Not provided by job post"}
          />
          <Attribute
            label="Last Updated Date"
            value={updatedDate || "Not provided by job post"}
          />
        </Box>
        {/* Apply Button */}
        <Box
          mt={3}
          textAlign="center"
          sx={{
            float: "right",
          }}
        >
          <Button variant="contained" color="primary" href={job_applyUrl}>
            Apply
          </Button>
        </Box>
      </CardContent>
    </Card>
  );
};
