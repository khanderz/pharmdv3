import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';

export const JobRoleFilter = () => {
  const {
    selectedJobRoles,
    setSelectedJobRoles,
    uniqueJobRoles,
    jobRolesLoading,
  } = useFiltersContext();

  return (
    <Autocomplete
      multiple
      inputLabel="Job Roles"
      options={uniqueJobRoles.map((jobRole) => ({
        key: jobRole.id,
        value: jobRole.role_name,
      }))}
      value={(selectedJobRoles ?? []).map((jr) => jr.role_name)}
      onChange={(e, value) => {
        const selectedValues = (value as string[]).filter(Boolean);

        const selected = uniqueJobRoles.filter((jobRole) =>
          selectedValues.includes(jobRole.role_name)
        );

        setSelectedJobRoles(selected);
      }}
      loading={jobRolesLoading}
      disableClearable={false}
    />
  );
};
