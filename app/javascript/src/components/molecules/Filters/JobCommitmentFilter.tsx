import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { JobCommitment } from '@customtypes/job_post';

export type JobCommitmentFilterProps = {
  jobCommitments: JobCommitment[];
  selectedJobCommitment: JobCommitment | null;
  onJobCommitmentFilter: (jobCommitment: JobCommitment | null) => void;
};

export const JobCommitmentFilter = ({
  jobCommitments,
  selectedJobCommitment,
  onJobCommitmentFilter,
}: JobCommitmentFilterProps) => {
  return (
    <Select
      inputLabel="Job Commitment Types"
      value={selectedJobCommitment?.id || ''}
      onChange={(e) => {
        const jobCommitment = jobCommitments.find(
          (jobCommitment) => jobCommitment.id === e.target.value
        );
        onJobCommitmentFilter(jobCommitment || null);
      }}
    >
      {jobCommitments.map((jobCommitment) => (
        <MenuItem key={jobCommitment.id} value={jobCommitment.id}>
          {jobCommitment.commitment_name}
        </MenuItem>
      ))}
    </Select>
  );
};
