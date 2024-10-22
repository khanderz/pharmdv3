import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { CompanySpecialty } from '@customtypes/company';

export type SpecialtyFilterProps = {
  specialties: CompanySpecialty[];
  selectedSpecialty: CompanySpecialty | null;
  onSpecialtyFilter: (specialty: CompanySpecialty | null) => void;
};

export const SpecialtyFilter = ({
  specialties,
  selectedSpecialty,
  onSpecialtyFilter,
}: SpecialtyFilterProps) => {
  return (
    <Select
      inputLabel="Specialties"
      value={selectedSpecialty?.key || ''}
      onChange={(e) => {
        const specialty = specialties.find(
          (specialty) => specialty.key === e.target.value
        );
        onSpecialtyFilter(specialty || null);
      }}
    >
      {specialties.map((specialty) => (
        <MenuItem key={specialty.key} value={specialty.key}>
          {specialty.value}
        </MenuItem>
      ))}
    </Select>
  );
};
