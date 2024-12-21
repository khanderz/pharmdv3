import React from "react";
import { Card, CardContent, Typography } from "@mui/material";
import {
  Company,
  CompanySpecialty,
  HealthcareDomain,
} from "@customtypes/company";
import { JobCommitment, JobPost, JobSetting } from "@customtypes/job_post";
import { Button } from "@components/atoms/Button";

interface JobCardProps {
  title: JobPost["job_title"];
  company_name: Company["company_name"];
  job_location?: any;
  job_setting: JobSetting["setting_name"];
  job_commitment: JobCommitment["commitment_name"];
  job_applyUrl: JobPost["job_applyUrl"];
  company_specialty: CompanySpecialty["value"][];
  healthcare_domains: HealthcareDomain["value"][];
  job_posted: JobPost["job_posted"];
}

export const JobCard = ({
  title,
  company_name,
  job_applyUrl,
  company_specialty,
  job_posted,
  job_location,
  job_commitment,
  healthcare_domains,
}: JobCardProps) => {
  const jobPostDate = new Date(job_posted).toLocaleDateString();

  // Determine pluralization based on array lengths
  const specialtyLabel =
    company_specialty && company_specialty.length > 1
      ? "Specialties"
      : "Specialty";
  const domainsLabel =
    healthcare_domains && healthcare_domains.length > 1
      ? "Healthcare Domains"
      : "Healthcare Domain";

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
        <Typography variant="body2" color="text.secondary">
          {company_name || "Unknown Company"}
        </Typography>
        <Typography variant="body2" sx={{ mt: 1 }}>
          {specialtyLabel}:{" "}
          {company_specialty.length > 0 ? company_specialty.join(", ") : "N/A"}
        </Typography>
        <Typography variant="body2" sx={{ mt: 1 }}>
          {domainsLabel}:{" "}
          {healthcare_domains.length > 0
            ? healthcare_domains.join(", ")
            : "N/A"}
        </Typography>
        <Typography variant="body2" sx={{ mt: 1 }}>
          Job Posted Date: {jobPostDate || "N/A"}
        </Typography>
        <Typography variant="body2" sx={{ mt: 1 }}>
          Location: {job_location || "N/A"}
        </Typography>
        <Typography variant="body2" sx={{ mt: 1 }}>
          Job Commitment Type: {job_commitment || "N/A"}
        </Typography>
        <Button
          variant="contained"
          color="primary"
          sx={{ mt: 2 }}
          href={job_applyUrl}
        >
          Apply
        </Button>
      </CardContent>
    </Card>
  );
};
