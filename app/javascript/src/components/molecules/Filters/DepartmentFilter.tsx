import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { AutocompleteOption } from '@components/atoms/Autocomplete';

export const DepartmentFilter = () => {
  const {
    selectedDepartments,
    setSelectedDepartments,
    departments,
    departmentsLoading,
  } = useFiltersContext();

  const options = departments.map((department) => ({
    key: department.id,
    value: department.dept_name,
  }));

  const selectedOptions = selectedDepartments.map((selected) => {
    const department = options.find(
      (option) => option.value === selected.dept_name
    );

    return {
      key: department?.key ?? '',
      value: department?.value ?? '',
    };
  });

  return (
    <Autocomplete
      id={'department-autocomplete'}
      multiple
      inputLabel="Departments"
      options={options}
      value={selectedOptions}
      onChange={(e, value) => {
        const selectedValues = (value as AutocompleteOption[]).filter(Boolean);

        const selected = departments.filter((department) =>
          selectedValues.some((el) => el.value === department.dept_name)
        );

        setSelectedDepartments(selected);
      }}
      loading={departmentsLoading}
    />
  );
};
