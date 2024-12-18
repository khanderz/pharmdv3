import React from 'react';
import {
  Autocomplete as MuiAutocomplete,
  TextField as MuiTextField,
  Box,
} from '@mui/material';

export interface AutocompleteOption {
  key: string | number;
  value: string | number;
}

export type AutocompleteProps = {
  inputLabel: string;
  options: AutocompleteOption[];
  value: AutocompleteOption | AutocompleteOption[] | null;
  multiple?: boolean;
  id?: string;
  loading?: boolean;
  onChange: (
    event: React.SyntheticEvent<Element, Event>,
    value: AutocompleteOption | AutocompleteOption[] | null
  ) => void;
  sx?: Record<string, any>;
  inputValue?: string;
  onInputChange?: (event: React.ChangeEvent<{}>, value: string) => void;
};

export const Autocomplete = ({
  inputLabel,
  options,
  value,
  multiple = false,
  id,
  loading = false,
  onChange,
  sx,
  inputValue,
  onInputChange,
}: AutocompleteProps) => {
  const valueProp = value ?? (multiple ? [] : null);

  return (
    <Box
      data-testid={`${inputLabel}-autocomplete-box`}
      sx={{
        mt: 2,
        ...sx,
      }}
    >
      <MuiAutocomplete
        fullWidth
        data-testid={`${inputLabel}-autocomplete`}
        value={valueProp}
        multiple={multiple}
        id={id}
        options={options}
        onChange={(e, newValue) => {
          onChange(e, newValue ?? (multiple ? [] : null));
        }}
        loadingText="Loading..."
        loading={loading}
        sx={{
          mt: '2em',
        }}
        getOptionLabel={(option) => {
          return option?.value?.toString();
        }}
        inputValue={inputValue}
        onInputChange={onInputChange}
        renderInput={(params) => (
          <MuiTextField
            {...params}
            label={inputLabel}
            variant="outlined"
            placeholder={inputLabel}
          />
        )}
      />
    </Box>
  );
};
