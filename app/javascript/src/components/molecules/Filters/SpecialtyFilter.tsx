import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { CompanySpecialty } from '@customtypes/company';

export type SpecialtyFilterProps = {
  specialties: CompanySpecialty[];
  selectedSpecialties: CompanySpecialty[] | null;
  onSpecialtyFilter: React.Dispatch<
    React.SetStateAction<CompanySpecialty[] | null>
  >;
};

export const SpecialtyFilter = ({
  specialties,
  selectedSpecialties,
  onSpecialtyFilter,
}: SpecialtyFilterProps) => {
  return (
    <Autocomplete
      multiple
      inputLabel="Specialties"
      options={specialties.map((specialty) => ({
        key: specialty.key,
        value: specialty.value,
      }))}
      value={(selectedSpecialties ?? []).map((s) => s.value)}
      onChange={(e, value) => {
        const selectedValues = (value as CompanySpecialty['value'][]).filter(
          Boolean
        );

        const selected = specialties.filter((specialty) =>
          selectedValues.includes(specialty.value)
        );

        onSpecialtyFilter(selected);
      }}
      loading={false}
      disableClearable={false}
    />
  );
};
