import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';

export const JobCommitmentFilter = () => {
  const {
    selectedJobCommitments,
    setSelectedJobCommitments,
    jobCommitments,
    jobCommitmentsLoading,
  } = useFiltersContext();

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
        const selectedValues = (value as string[]).filter(Boolean);

        const selected = jobCommitments.filter((commitment) =>
          selectedValues.includes(commitment.commitment_name)
        );

        setSelectedJobCommitments(selected);
      }}
      loading={jobCommitmentsLoading}
    />
  );
};
