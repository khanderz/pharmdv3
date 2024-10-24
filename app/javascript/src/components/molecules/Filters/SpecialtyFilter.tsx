import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';

export const SpecialtyFilter = () => {
  const { selectedSpecialties, setSelectedSpecialties, uniqueSpecialties } =
    useFiltersContext();

  return (
    <Autocomplete
      multiple
      inputLabel="Specialties"
      options={uniqueSpecialties.map((specialty) => ({
        key: specialty.key,
        value: specialty.value,
      }))}
      value={(selectedSpecialties ?? []).map((s) => s.value)}
      onChange={(e, value) => {
        const selectedValues = (value as string[]).filter(Boolean);

        const selected = uniqueSpecialties.filter((specialty) =>
          selectedValues.includes(specialty.value)
        );

        setSelectedSpecialties(selected);
      }}
      loading={false}
      disableClearable={false}
    />
  );
};
