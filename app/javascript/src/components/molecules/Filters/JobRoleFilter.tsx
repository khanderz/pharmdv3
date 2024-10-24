import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { JobRole } from '@customtypes/job_role';

export type JobRoleFilterProps = {
  jobRoles: JobRole[];
  selectedJobRoles: JobRole[] | null;
  onJobRoleFilter: React.Dispatch<React.SetStateAction<JobRole[] | null>>;
  jobRolesLoading: boolean;
};

export const JobRoleFilter = ({
  jobRoles,
  selectedJobRoles,
  onJobRoleFilter,
  jobRolesLoading,
}: JobRoleFilterProps) => {
  return (
    <Autocomplete
      multiple
      inputLabel="Job Roles"
      options={jobRoles.map((jobRole) => ({
        key: jobRole.id,
        value: jobRole.role_name,
      }))}
      value={(selectedJobRoles ?? []).map((jr) => jr.role_name)}
      onChange={(e, value) => {
        const selectedValues = (value as JobRole['role_name'][]).filter(
          Boolean
        );

        const selected = jobRoles.filter((jobRole) =>
          selectedValues.includes(jobRole.role_name)
        );

        onJobRoleFilter(selected);
      }}
      loading={jobRolesLoading}
      disableClearable={false}
    />
  );
};
