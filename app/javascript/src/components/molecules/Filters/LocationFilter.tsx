import React, { useMemo, useState } from "react";
import { Autocomplete } from "@components/atoms";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";
import { AutocompleteOption } from "@components/atoms/Autocomplete";

export const LocationFilter = () => {
  const {
    filteredJobPosts,
    selectedLocation,
    setSelectedLocation,
    uniqueLocations,
  } = useFiltersContext();
  console.log({ uniqueLocations });
  const [inputValue, setInputValue] = useState("");

  const locationOptions: AutocompleteOption[] = useMemo(
    () =>
      uniqueLocations.map(location => ({
        key: location.id.toString(),
        value: location.name,
      })),
    [uniqueLocations],
  );

  const filteredLocations: AutocompleteOption[] = useMemo(() => {
    if (!inputValue) return locationOptions;
    const lowerInput = inputValue.toLowerCase();
    const matches = locationOptions.filter(location =>
      location.value.toLowerCase().includes(lowerInput),
    );
    return matches.length > 0
      ? matches
      : [{ key: "no-matches", value: "No matching job post locations" }];
  }, [inputValue, locationOptions]);

  const handleLocationChange = (
    event: React.SyntheticEvent<Element, Event>,
    newValue: AutocompleteOption | null,
  ) => {
    if (newValue && newValue.value !== "No matching job post locations") {
      const selected = uniqueLocations.find(
        location => location.name === newValue.value,
      );
      setSelectedLocation(
        selected ? { key: selected.id.toString(), value: selected.name } : null,
      );
    } else {
      setSelectedLocation(null);
    }
  };

  return (
    <Autocomplete
      id="location-autocomplete"
      inputLabel="Location"
      options={filteredLocations}
      value={
        selectedLocation
          ? { key: selectedLocation.key, value: selectedLocation.value }
          : null
      }
      onChange={handleLocationChange}
      inputValue={inputValue}
      onInputChange={(e: any, newInputValue: string) =>
        setInputValue(newInputValue)
      }
    />
  );
};
