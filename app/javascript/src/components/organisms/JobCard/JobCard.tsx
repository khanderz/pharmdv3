import React from "react";
import { Card, CardContent, Typography } from "@mui/material";
import { Company, HealthcareDomain } from "@customtypes/company";
import { JobCommitment, JobPost, JobSetting } from "@customtypes/job_post";
import { Button } from "@components/atoms/Button";
import { Attribute } from "@javascript/components/atoms/Attribute";

interface JobCardProps {
  title: JobPost["job_title"];
  company_name: Company["company_name"];
  job_location?: any;
  job_setting: JobSetting["setting_name"];
  job_commitment: JobCommitment["commitment_name"];
  job_applyUrl: JobPost["job_applyUrl"];
  healthcare_domains: HealthcareDomain["value"][];
  job_posted: JobPost["job_posted"];
  updatedDate: JobPost["updated_at"];
}

export const JobCard = ({
  title,
  company_name,
  job_applyUrl,
  job_posted,
  job_location,
  job_commitment,
  healthcare_domains,
  updatedDate,
}: JobCardProps) => {
  const jobPostDate = job_posted
    ? new Date(job_posted).toLocaleDateString()
    : "";
  console.log({ healthcare_domains });
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
        {/* <Typography variant="body2" sx={{ mt: 1 }}>
          {domainsLabel}:{" "}
          {healthcare_domains.length > 0
            ? healthcare_domains.join(", ")
            : "N/A"}
        </Typography> */}
        <Attribute label={domainsLabel} value={healthcare_domains} renderChip />
        <Attribute
          label="Posted Date"
          value={jobPostDate || "Not provided by job post"}
        />
        <Attribute
          label="Last Updated Date"
          value={updatedDate || "Not provided by job post"}
        />
        <Attribute label="Location" value={job_location || "N/A"} />
        <Attribute
          label="Job Commitment Type"
          value={job_commitment || "N/A"}
        />

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
