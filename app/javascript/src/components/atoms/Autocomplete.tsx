import React from 'react';
import {
  Autocomplete as MuiAutocomplete,
  TextField as MuiTextField,
  Box,
  Typography,
} from '@mui/material';

interface AutocompleteOptions {
  key: string | number;
  value: string | number;
}

export type AutocompleteProps = {
  inputLabel: string;
  options: AutocompleteOptions[];
  value: string | number | (string | number)[];
  multiple?: boolean;
  id?: string;
  loading?: boolean;
  disableClearable?: boolean;
  onChange: (
    event: React.SyntheticEvent<Element, Event>,
    value: string | number | (string | number)[]
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
  const valueProp = value ?? (multiple ? [] : '');

  return (
    <Box
      data-testid={`${inputLabel}-autocomplete-box`}
      sx={{
        mt: 2,
      }}
    >
      <MuiAutocomplete
        data-testid={`${inputLabel}-autocomplete`}
        value={valueProp}
        multiple={multiple}
        id={id}
        options={options.map((option) => option.value)} // Pass only the values from options
        onChange={(e, value) => {
          onChange(e, value ?? (multiple ? [] : ''));
        }}
        loadingText="Loading..."
        loading={loading}
        disableClearable={disableClearable}
        sx={sx}
        renderInput={(params) => (
          <MuiTextField
            {...params}
            label={inputLabel}
            variant="outlined"
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
