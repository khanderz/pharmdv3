import React from 'react';
import {
  Select as MuiSelect,
  MenuItem as MuiMenuItem,
  SelectProps as MuiSelectProps,
  InputLabel,
  Box,
  Typography,
} from '@mui/material';

export type SelectProps = MuiSelectProps & {
  inputLabel: string;
  children: any;
};

export const Select = ({ inputLabel, children, ...props }: SelectProps) => {
  const value = props.value ?? (props.multiple ? [] : '');

  return (
    <Box
      data-testid={`${inputLabel}-select-box`}
      sx={{
        mt: 2,
      }}
    >
      <InputLabel
        id={`${inputLabel}-input-label`}
        data-testid={`${inputLabel}-input-label`}
        style={{ display: 'none' }}
      >
        {inputLabel}
      </InputLabel>
      <Typography component="label">{inputLabel}</Typography>
      <MuiSelect
        {...props}
        labelId={`${inputLabel}-input-label`}
        value={value}
        onChange={props.onChange}
        displayEmpty
        label={inputLabel}
        renderValue={(selected) => {
          // If the selection is an array and empty
          if (Array.isArray(selected) && selected.length === 0) {
            return <em>All {inputLabel}</em>;
          }

          // If it's a multi-select, join selected values
          if (Array.isArray(selected)) {
            return selected.join(', ');
          }

          // Handle single-select case or empty value
          if (selected === '' || selected === null || selected === undefined) {
            return <em>All {inputLabel}</em>;
          }

          // Return the selected value as string
          return String(selected);
        }}
        sx={{
          width: '100%',
          mt: 0.5,
          '& .MuiOutlinedInput-notchedOutline': {
            top: 0,
            legend: {
              display: 'none',
            },
          },
          ...props.sx,
        }}
      >
        <MuiMenuItem value="">
          <em>All {inputLabel}</em>
        </MuiMenuItem>
        {children}
      </MuiSelect>
    </Box>
  );
};
