import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { JobRole } from '@customtypes/job_role';

export type JobRoleFilterProps = {
  jobRoles: JobRole[];
  selectedJobRole: JobRole | null;
  onJobRoleFilter: (jobRole: JobRole | null) => void;
};

export const JobRoleFilter = ({
  jobRoles,
  selectedJobRole,
  onJobRoleFilter,
}: JobRoleFilterProps) => {
  console.log({ jobRoles, selectedJobRole });
  return (
    <Select
      inputLabel="Job Roles"
      value={selectedJobRole?.id || ''}
      onChange={(e) => {
        const jobRole = jobRoles.find(
          (jobRole) => jobRole.id === e.target.value
        );
        onJobRoleFilter(jobRole || null);
      }}
    >
      {jobRoles.map((jobRole) => (
        <MenuItem key={jobRole.id} value={jobRole.id}>
          {jobRole.role_name}
        </MenuItem>
      ))}
    </Select>
  );
};
