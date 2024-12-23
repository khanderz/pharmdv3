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
    key: currency.id,
    value: `${currency.currency_code} (${currency.currency_sign})`,
  }));

  const selectedOption = options.find(
    option => option.key === selectedSalaryCurrency?.id,
  );

  return (
    <Autocomplete
      id="currency"
      inputLabel="Currency"
      options={options}
      value={selectedOption || null}
      onChange={(event, newValue) => {
        const selected = options.find(
          option => option.key === (newValue as AutocompleteOption)?.key,
        );

        setSelectedSalaryCurrency({
          id: selected.key,
          currency_code: selected.value.split(" ")[0],
          currency_sign: selected.value.match(/\((.*?)\)/)?.[1] || "$",
        } as JobSalaryCurrency);
      }}
      loading={currenciesLoading}
    />
  );
};
