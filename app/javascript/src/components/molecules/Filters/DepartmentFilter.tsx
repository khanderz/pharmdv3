import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { Department } from '@customtypes/job_role';

export type DepartmentFilterProps = {
  departments: Department[];
  selectedDepartments: Department[] | null;
  onDepartmentFilter: (department: Department[] | null) => void;
  resetDepartmentFilter: () => void;
};

export const DepartmentFilter = ({
  departments,
  selectedDepartments,
  onDepartmentFilter,
  resetDepartmentFilter,
}: DepartmentFilterProps) => {
  return (
    <Select
      multiple
      inputLabel="Departments"
      value={(selectedDepartments ?? []).map((d) => d.id)}
      onChange={(e) => {
        const selectedValues = e.target.value as Department['id'][];
        const selected = departments.filter((department) =>
          selectedValues.includes(department.id)
        );
        onDepartmentFilter(selected);
      }}
      renderValue={(selected) =>
        (selected as Department['id'][])
          .map((value) => departments.find((d) => d.id === value)?.dept_name)
          .join(', ')
      }
      onReset={resetDepartmentFilter}
    >
      {departments.map((department) => (
        <MenuItem key={department.id} value={department.id}>
          {department.dept_name}
        </MenuItem>
      ))}
    </Select>
  );
};
