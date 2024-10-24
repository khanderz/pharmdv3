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
        fullWidth
        data-testid={`${inputLabel}-autocomplete`}
        value={valueProp}
        multiple={multiple}
        id={id}
        options={options.map((option) => option.value)}
        onChange={(e, value) => {
          onChange(e, value ?? (multiple ? [] : ''));
        }}
        loadingText="Loading..."
        loading={loading}
        disableClearable={disableClearable}
        sx={{
          mt: 0.5,
          ...sx,
        }}
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
