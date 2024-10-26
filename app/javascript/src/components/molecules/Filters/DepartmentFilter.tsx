import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';

export const DepartmentFilter = () => {
  const {
    selectedDepartments,
    setSelectedDepartments,
    departments,
    departmentsLoading,
  } = useFiltersContext();

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
        const selectedValues = (value as string[]).filter(Boolean);

        const selected = departments.filter((department) =>
          selectedValues.includes(department.dept_name)
        );

        setSelectedDepartments(selected);
      }}
      loading={departmentsLoading}
    />
  );
};
