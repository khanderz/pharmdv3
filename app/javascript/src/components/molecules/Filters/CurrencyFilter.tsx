import React from 'react';
import { Autocomplete } from '@components/atoms';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { JobSalaryCurrency } from '@customtypes/job_post';
import { AutocompleteOption } from '@components/atoms/Autocomplete';

export const CurrencyFilter = () => {
  const {
    selectedSalaryCurrency,
    setSelectedSalaryCurrency,
    currenciesLoading,
    currencies,
  } = useFiltersContext();

  const options: AutocompleteOption[] = currencies.map((currency) => ({
    key: currency.key,
    value: currency.key,
    label: currency.label,
  }));

  const selectedOption = options.find(
    (option) => option.value === selectedSalaryCurrency
  );

  return (
    <Autocomplete
      inputLabel="Currency"
      options={options}
      value={selectedOption || null}
      multiple={false}  
      getOptionLabel={(option) =>
        option?.label ? option.label.toString() : ''
      }  
      onChange={(event, newValue) => {
        console.log({newValue})
        const selectedId = (newValue as AutocompleteOption)?.value as JobSalaryCurrency['key'] | null;
        setSelectedSalaryCurrency(selectedId || null); 
      }}
      id="currency-autocomplete"
      loading={currenciesLoading}
    />
  );
};
