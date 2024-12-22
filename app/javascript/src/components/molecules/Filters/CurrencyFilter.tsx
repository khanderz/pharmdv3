import React from "react";
import { Autocomplete } from "@components/atoms";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";
import { JobSalaryCurrency } from "@customtypes/job_post";
import { AutocompleteOption } from "@components/atoms/Autocomplete";

export const CurrencyFilter = () => {
  const {
    selectedSalaryCurrency,
    setSelectedSalaryCurrency,
    currenciesLoading,
    currencies,
  } = useFiltersContext();

  const options: AutocompleteOption[] = currencies.map(currency => ({
    id: currency.key,
    currency_code: currency.label,
  }));

  const selectedOption = options.find(
    option => option.key === selectedSalaryCurrency?.key,
  );

  return (
    <Autocomplete
      id="currency-autocomplete"
      inputLabel="Currency"
      options={options}
      value={selectedOption || null}
      onChange={(event, newValue) => {
        const selected = options.find(
          currency => currency.key === (newValue as AutocompleteOption).key,
        ) || { key: 14, value: "USD" };

        setSelectedSalaryCurrency({
          id: selected.key,
          currency_code: selected.value,
        } as JobSalaryCurrency);
      }}
      loading={currenciesLoading}
    />
  );
};
