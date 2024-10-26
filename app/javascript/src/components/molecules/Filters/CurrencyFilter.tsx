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
    value: currency.label,
  }));

  const selectedOptions = selectedSalaryCurrency?.map((selected) => {
    const currency = options.find((option) => option.value === selected.label);

    return {
      key: currency?.key ?? '',
      value: currency?.value ?? '',
    };
  });

  return (
    <Autocomplete
      id="currency-autocomplete"
      inputLabel="Currency"
      options={options}
      value={selectedOptions}
      multiple
      onChange={(event, newValue) => {
        const selectedValues = (newValue as AutocompleteOption[]).filter(
          Boolean
        );
        const selected = currencies.filter((currency) =>
          selectedValues.some((el) => el.value === currency.label)
        );
        setSelectedSalaryCurrency(selected);
      }}
      loading={currenciesLoading}
    />
  );
};
