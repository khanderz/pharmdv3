import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { Department } from '@customtypes/job_role';

export type DepartmentFilterProps = {
  departments: Department[];
  selectedDepartments: Department[] | null;
  onDepartmentFilter: React.Dispatch<React.SetStateAction<Department[] | null>>;
  departmentsLoading: boolean;
};

export const DepartmentFilter = ({
  departments,
  selectedDepartments,
  onDepartmentFilter,
  departmentsLoading,
}: DepartmentFilterProps) => {
  return (
    <Autocomplete
      multiple
      inputLabel="Departments"
      options={departments.map((department) => ({
        key: department.id,
        value: department.dept_name,
      }))}
      value={(selectedDepartments ?? []).map((d) => d.dept_name)}
      onChange={(e, value) => {
        const selectedValues = (value as Department['dept_name'][]).filter(
          Boolean
        );

        const selected = departments.filter((department) =>
          selectedValues.includes(department.dept_name)
        );

        onDepartmentFilter(selected);
      }}
      loading={departmentsLoading}
      disableClearable={false}
    />
  );
};
