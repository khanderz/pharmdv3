import React, { useMemo, useState } from 'react';
import { Autocomplete } from '@components/atoms';
import { useFiltersContext } from '@javascript/providers/FiltersProvider';
import { AutocompleteOption } from '@components/atoms/Autocomplete';

export const LocationFilter = () => {
  const { filteredJobPosts, selectedLocation, setSelectedLocation } =
    useFiltersContext();
  const [inputValue, setInputValue] = useState('');

  const uniqueLocations: AutocompleteOption[] = useMemo(() => {
    const locations = filteredJobPosts.flatMap((jobPost) =>
      Array.isArray(jobPost.job_locations)
        ? jobPost.job_locations
        : [jobPost.job_locations]
    );
    const deduplicatedLocations = Array.from(new Set(locations));

    return deduplicatedLocations
      .sort((a, b) => a.localeCompare(b))
      .map((location, index) => ({
        key: index,
        value: location,
      }));
  }, [filteredJobPosts]);

  const filteredLocations: AutocompleteOption[] = useMemo(() => {
    if (!inputValue) return uniqueLocations;
    const lowerInput = inputValue.toLowerCase();
    const matches = uniqueLocations.filter((location) =>
      (location.value as string).toLowerCase().includes(lowerInput)
    );

    return matches.length > 0
      ? matches
      : [{ key: 'no-matches', value: 'No matching job post locations' }];
  }, [inputValue, uniqueLocations]);

  const handleLocationChange = (
    event: React.SyntheticEvent<Element, Event>,
    newValue: AutocompleteOption | null
  ) => {
    if (newValue && newValue.value !== 'No matching job post locations') {
      setSelectedLocation(newValue as AutocompleteOption);
    } else {
      setSelectedLocation(null);
    }
  };

  return (
    <Autocomplete
      id="location-autocomplete"
      inputLabel="Location"
      options={filteredLocations}
      value={selectedLocation}
      onChange={handleLocationChange}
      inputValue={inputValue}
      onInputChange={(e: any, newInputValue: string) =>
        setInputValue(newInputValue)
      }
    />
  );
};
