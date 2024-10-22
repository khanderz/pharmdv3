import React from 'react';
import { Select } from '@components/atoms/Select';
import { MenuItem } from '@mui/material';
import { Department } from '@customtypes/job_role';

export type DepartmentFilterProps = {
  departments: Department[];
  selectedDepartment: Department | null;
  onDepartmentFilter: (department: Department | null) => void;
};

export const DepartmentFilter = ({
  departments,
  selectedDepartment,
  onDepartmentFilter,
}: DepartmentFilterProps) => {
  return (
    <Select
      inputLabel="Departments"
      value={selectedDepartment?.id || ''}
      onChange={(e) => {
        const department = departments.find(
          (department) => department.id === e.target.value
        );
        onDepartmentFilter(department || null);
      }}
    >
      {departments.map((department) => (
        <MenuItem key={department.id} value={department.id}>
          {department.dept_name}
        </MenuItem>
      ))}
    </Select>
  );
};
