import React, { useMemo, useState } from "react";
import { Autocomplete } from "@components/atoms";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";
import { AutocompleteOption } from "@components/atoms/Autocomplete";

export const LocationFilter = () => {
  const { selectedLocations, setSelectedLocations, uniqueLocations } =
    useFiltersContext();

  const [inputValue, setInputValue] = useState("");

  const locationMap = useMemo(() => {
    const map: Record<number, string | null> = {};
    uniqueLocations.forEach(location => {
      map[location.id] = location.name || null;
    });
    return map;
  }, [uniqueLocations]);

  const locationOptions: AutocompleteOption[] = useMemo(
    () =>
      uniqueLocations.map(location => ({
        key: location.id.toString(),
        value: location.name,
        display: location.parent_id
          ? `${location.name} (${locationMap[location.parent_id]})`
          : location.name,
      })),
    [uniqueLocations, locationMap],
  );

  const filteredLocations: AutocompleteOption[] = useMemo(() => {
    if (!inputValue) return locationOptions;
    const lowerInput = inputValue.toLowerCase();
    const matches = locationOptions.filter(
      location =>
        location.value.toLowerCase().includes(lowerInput) ||
        (location.display &&
          location.display.toLowerCase().includes(lowerInput)),
    );
    return matches.length > 0
      ? matches
      : [{ key: "no-matches", value: "No matching job post locations" }];
  }, [inputValue, locationOptions]);

  const handleLocationChange = (
    event: React.SyntheticEvent<Element, Event>,
    newValue: AutocompleteOption[] | null,
  ) => {
    if (newValue && newValue.length > 0) {
      const validLocations = newValue.filter(
        location => location.value !== "No matching job post locations",
      );
      setSelectedLocations(validLocations);
    } else {
      setSelectedLocations([]);
    }
  };

  return (
    <Autocomplete
      id="location-autocomplete"
      inputLabel="Location"
      multiple
      options={filteredLocations.map(location => ({
        key: location.key,
        value: location.value,
        display: location.display,
      }))}
      value={selectedLocations.map(location => ({
        key: location.key,
        value: location.value,
      }))}
      getOptionLabel={option => option.display}
      onChange={handleLocationChange}
      inputValue={inputValue}
      onInputChange={(e: any, newInputValue: string) =>
        setInputValue(newInputValue)
      }
    />
  );
};
