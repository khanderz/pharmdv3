import React from 'react';
import {
  Autocomplete as MuiAutocomplete,
  TextField as MuiTextField,
  Box,
  Typography,
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
  disableClearable?: boolean;
  onChange: (
    event: React.SyntheticEvent<Element, Event>,
    value: AutocompleteOption | AutocompleteOption[] | null
  ) => void;
  sx?: Record<string, any>;
};

export const Autocomplete = ({
  inputLabel,
  options,
  value,
  multiple = false,
  id,
  loading = false,
  disableClearable = false,
  onChange,
  sx,
}: AutocompleteProps) => {
  const valueProp = value ?? (multiple ? [] : null);

  return (
    <Box
      data-testid={`${inputLabel}-autocomplete-box`}
      sx={{
        mt: 2,
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
        isOptionEqualToValue={(
          option: AutocompleteOption,
          value: AutocompleteOption
        ) => {
          return option.key === value.key;
        }}
        loadingText="Loading..."
        loading={loading}
        disableClearable={disableClearable}
        sx={{
          mt: '2em',
          ...sx,
        }}
        getOptionLabel={(option) =>
          option.value ? option.value.toString() : ''
        } // <- Safely handling null/undefined values
        renderInput={(params) => (
          <MuiTextField
            {...params}
            label={inputLabel}
            variant="outlined"
            placeholder={inputLabel}
            InputLabelProps={{ shrink: true }}
            InputProps={{
              ...params.InputProps,
              endAdornment: (
                <>
                  {loading && <Typography>Loading...</Typography>}
                  {params.InputProps.endAdornment}
                </>
              ),
            }}
          />
        )}
      />
    </Box>
  );
};
