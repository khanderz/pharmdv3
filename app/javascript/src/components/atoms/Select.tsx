import React from 'react';
import {
  Select as MuiSelect,
  MenuItem as MuiMenuItem,
  SelectProps as MuiSelectProps,
  InputLabel,
  Box,
} from '@mui/material';

export type SelectOption = {
  key: string;
  value: string;
};

export type SelectProps = MuiSelectProps & {
  inputLabel: string;
  options: SelectOption[];
};

export const Select = ({ inputLabel, options, ...props }: SelectProps) => {
  return (
    <Box
      data-testid={`${inputLabel}-select-box`}
      sx={{
        ...props.sx,
      }}
    >
      <InputLabel
        id={`${inputLabel}-input-label`}
        data-testid={`${inputLabel}-input-label`}
      >
        {inputLabel}
      </InputLabel>
      <MuiSelect
        {...props}
        labelId={`${inputLabel}-input-label`}
        value={props.value}
        onChange={props.onChange}
        displayEmpty
        label={inputLabel}
        sx={{ ...props.sx }}
      >
        <MuiMenuItem value="">
          <em>All {inputLabel}</em>
        </MuiMenuItem>
        {options.map((option) => (
          <MuiMenuItem key={option.key} value={option.value}>
            {option.value}
          </MuiMenuItem>
        ))}
      </MuiSelect>
    </Box>
  );
};
