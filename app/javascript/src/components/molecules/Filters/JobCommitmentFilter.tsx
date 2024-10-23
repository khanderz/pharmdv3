import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { JobCommitment } from '@customtypes/job_post';

export type JobCommitmentFilterProps = {
  jobCommitments: JobCommitment[];
  selectedJobCommitments: JobCommitment[] | null;
  onJobCommitmentFilter: (jobCommitment: JobCommitment[] | null) => void;
  resetJobCommitmentFilter: () => void;
};

export const JobCommitmentFilter = ({
  jobCommitments,
  selectedJobCommitments,
  onJobCommitmentFilter,
  resetJobCommitmentFilter,
}: JobCommitmentFilterProps) => {
  return (
    <Select
      multiple
      inputLabel="Job Commitment Types"
      value={(selectedJobCommitments ?? []).map(
        (c) => c.id as JobCommitment['id']
      )}
      onChange={(e) => {
        const selectedValues = e.target.value as JobCommitment['id'][];
        const selected = jobCommitments.filter((jobCommitment) =>
          selectedValues.includes(jobCommitment.id)
        );
        onJobCommitmentFilter(selected);
      }}
      renderValue={(selected) =>
        (selected as JobCommitment['id'][])
          .map(
            (value) =>
              jobCommitments.find((c) => c.id === value)?.commitment_name
          )
          .join(', ')
      }
      onReset={resetJobCommitmentFilter}
    >
      {jobCommitments.map((jobCommitment) => (
        <MenuItem key={jobCommitment.id} value={jobCommitment.id}>
          {jobCommitment.commitment_name}
        </MenuItem>
      ))}
    </Select>
  );
};
