import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { CompanySpecialty } from '@customtypes/company';

export type SpecialtyFilterProps = {
  specialties: CompanySpecialty[];
  selectedSpecialties: CompanySpecialty[] | null;
  onSpecialtyFilter: (specialties: CompanySpecialty[] | null) => void;
};

export const SpecialtyFilter = ({
  specialties,
  selectedSpecialties,
  onSpecialtyFilter,
}: SpecialtyFilterProps) => {
  return (
    <Select
      multiple
      inputLabel="Specialties"
      value={(selectedSpecialties ?? []).map(
        (s) => s.key as CompanySpecialty['key']
      )}
      onChange={(e) => {
        const selectedValues = e.target.value as CompanySpecialty['key'][];
        const selected = specialties.filter((specialty) =>
          selectedValues.includes(specialty.key)
        );
        onSpecialtyFilter(selected);
      }}
      renderValue={(selected) =>
        (selected as CompanySpecialty['value'][])
          .map((value) => specialties.find((s) => s.key === value)?.value)
          .join(', ')
      }
    >
      {specialties.map((specialty) => (
        <MenuItem key={specialty.key} value={specialty.key}>
          {specialty.value}
        </MenuItem>
      ))}
    </Select>
  );
};
