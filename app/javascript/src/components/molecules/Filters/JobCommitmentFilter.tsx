import React from "react";
import { Autocomplete } from "@components/atoms/index";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";
import { AutocompleteOption } from "@components/atoms/Autocomplete";

export const JobCommitmentFilter = () => {
  const {
    selectedJobCommitments,
    setSelectedJobCommitments,
    jobCommitments,
    jobCommitmentsLoading,
  } = useFiltersContext();

  const options = jobCommitments.map(commitment => ({
    key: commitment.id,
    value: commitment.commitment_name,
  }));

  const selectedOptions = selectedJobCommitments.map(selected => {
    const commitment = options.find(
      option => option.value === selected.commitment_name,
    );

    return {
      key: commitment?.key ?? "",
      value: commitment?.value ?? "",
    };
  });

  return (
    <Autocomplete
      id={"job-commitment-autocomplete"}
      multiple
      inputLabel="Job Commitment Types"
      options={options}
      value={selectedOptions}
      onChange={(e, value) => {
        const selectedValues = (value as AutocompleteOption[]).filter(Boolean);

        const selected = jobCommitments.filter(commitment =>
          selectedValues.some(el => el.value === commitment.commitment_name),
        );

        setSelectedJobCommitments(selected);
      }}
      loading={jobCommitmentsLoading}
    />
  );
};
