import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { AutocompleteOption } from '@components/atoms/Autocomplete';

export const JobRoleFilter = () => {
  const {
    selectedJobRoles,
    setSelectedJobRoles,
    uniqueJobRoles,
    jobRolesLoading,
  } = useFiltersContext();

  const options = uniqueJobRoles.map((jobRole) => ({
    key: jobRole.id,
    value: jobRole.role_name,
  }));

  const selectedOptions = selectedJobRoles.map((selected) => {
    const jobRole = uniqueJobRoles.find((jr) => jr.id === selected.id);

    return {
      key: jobRole?.id ?? '',
      value: jobRole?.role_name ?? '',
    };
  });

  return (
    <Autocomplete
      id={'job-role-autocomplete'}
      multiple
      inputLabel="Job Roles"
      options={options}
      value={selectedOptions}
      onChange={(e, value) => {
        const selectedValues = (value as AutocompleteOption[]).filter(Boolean);

        const selected = uniqueJobRoles.filter((jobRole) =>
          selectedValues.some((el) => el.value === jobRole.role_name)
        );

        setSelectedJobRoles(selected);
      }}
      loading={jobRolesLoading}
    />
  );
};
