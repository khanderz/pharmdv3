import React from "react";
import { Autocomplete } from "@components/atoms/index";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";
import { AutocompleteOption } from "@components/atoms/Autocomplete";

export const SpecialtyFilter = () => {
  const { selectedSpecialties, setSelectedSpecialties, uniqueSpecialties } =
    useFiltersContext();

  const options = uniqueSpecialties.map(specialty => ({
    key: specialty.key,
    value: specialty.value,
  }));

  const selectedOptions = selectedSpecialties.map(selected => {
    const specialty = uniqueSpecialties.find(
      specialty => specialty.key === selected.key,
    );
    return {
      key: specialty?.key ?? "",
      value: specialty?.value ?? "",
    };
  });
  return (
    <Autocomplete
      disable
      id={"specialty-filter"}
      multiple
      inputLabel="Specialties"
      options={options}
      value={selectedOptions}
      onChange={(e, value) => {
        const selectedValues = (value as AutocompleteOption[]).filter(Boolean);

        const selected = uniqueSpecialties.filter(specialty =>
          selectedValues.some(el => el.value === specialty.value),
        );

        setSelectedSpecialties(selected);
      }}
      loading={false}
      tooltipMessage="Under construction"
      readMoreLink={`/directory`}
    />
  );
};
