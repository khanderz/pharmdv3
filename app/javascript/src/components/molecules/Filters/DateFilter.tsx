import React from 'react';
import { Autocomplete } from '@components/atoms/index';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { AutocompleteOption } from '@components/atoms/Autocomplete';

export const DateFilter = () => {
  const { selectedDatePosted, setSelectedDatePosted } = useFiltersContext();

  const options: AutocompleteOption[] = [
    { key: 1, value: 'Past 24 hours' },
    { key: 2, value: 'Past 3 days' },
    { key: 3, value: 'Past week' },
    { key: 4, value: 'Past month' },
  ];
  const selectedOption =
    options.find((option) => option.value === selectedDatePosted) || null;

  return (
    <Autocomplete
      inputLabel="Date Posted"
      options={options}
      value={selectedOption}
      onChange={(event, newValue) => {
        const selectedValue = (newValue as AutocompleteOption)?.value || '';
        setSelectedDatePosted(selectedValue as string);
      }}
      id="date-posted-autocomplete"
    />
  );
};
