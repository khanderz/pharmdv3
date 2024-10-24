import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { JobCommitment } from '@customtypes/job_post';

export type JobCommitmentFilterProps = {
  jobCommitments: JobCommitment[];
  selectedJobCommitments: JobCommitment[] | null;
  onJobCommitmentFilter: React.Dispatch<
    React.SetStateAction<JobCommitment[] | null>
  >;
  jobCommitmentsLoading: boolean;
};

export const JobCommitmentFilter = ({
  jobCommitments,
  selectedJobCommitments,
  onJobCommitmentFilter,
  jobCommitmentsLoading,
}: JobCommitmentFilterProps) => {
  return (
    <Autocomplete
      multiple
      inputLabel="Job Commitment Types"
      options={jobCommitments.map((commitment) => ({
        key: commitment.id,
        value: commitment.commitment_name,
      }))}
      value={(selectedJobCommitments ?? []).map((c) => c.commitment_name)}
      onChange={(e, value) => {
        const selectedValues = (
          value as JobCommitment['commitment_name'][]
        ).filter(Boolean);

        const selected = jobCommitments.filter((jobCommitment) =>
          selectedValues.includes(jobCommitment.commitment_name)
        );

        onJobCommitmentFilter(selected);
      }}
      loading={jobCommitmentsLoading}
      disableClearable={false}
    />
  );
};
