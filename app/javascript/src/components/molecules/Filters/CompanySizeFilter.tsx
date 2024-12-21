import React from "react";
import { Autocomplete } from "@components/atoms";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";
import { AutocompleteOption } from "@components/atoms/Autocomplete";

export const CompanySizeFilter = () => {
  const {
    selectedCompanySize,
    setSelectedCompanySize,
    companySizesLoading,
    companySizes,
  } = useFiltersContext();

  const options: AutocompleteOption[] = companySizes.map(size => ({
    key: size.id,
    value: size.size_range,
  }));

  const selectedOptions = selectedCompanySize.map(selected => {
    const size = options.find(option => option.value === selected.size_range);

    return {
      key: size?.key ?? "",
      value: size?.value ?? "",
    };
  });

  return (
    <Autocomplete
      id="company-size-autocomplete"
      inputLabel="Company Size"
      options={options}
      value={selectedOptions}
      multiple
      onChange={(event, value) => {
        const selectedValues = (value as AutocompleteOption[]).filter(Boolean);
        const selected = companySizes.filter(size =>
          selectedValues.some(el => el.value === size.size_range),
        );

        setSelectedCompanySize(selected);
      }}
      loading={companySizesLoading}
    />
  );
};
