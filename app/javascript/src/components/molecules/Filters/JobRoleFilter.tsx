import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { JobRole } from '@customtypes/job_role';

export type JobRoleFilterProps = {
  jobRoles: JobRole[];
  selectedJobRoles: JobRole[] | null;
  onJobRoleFilter: (jobRole: JobRole[] | null) => void;
};

export const JobRoleFilter = ({
  jobRoles,
  selectedJobRoles,
  onJobRoleFilter,
}: JobRoleFilterProps) => {
  return (
    <Select
      multiple
      inputLabel="Job Roles"
      value={(selectedJobRoles ?? []).map((jr) => jr.id as JobRole['id'])}
      onChange={(e) => {
        const selectedValues = e.target.value as JobRole['id'][];
        const selected = jobRoles.filter((jobRole) =>
          selectedValues.includes(jobRole.id)
        );
        onJobRoleFilter(selected);
      }}
      renderValue={(selected) =>
        (selected as JobRole['id'][])
          .map((value) => jobRoles.find((jr) => jr.id === value)?.role_name)
          .join(', ')
      }
    >
      {jobRoles.map((jobRole) => (
        <MenuItem key={jobRole.id} value={jobRole.id}>
          {jobRole.role_name}
        </MenuItem>
      ))}
    </Select>
  );
};
