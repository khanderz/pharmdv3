import React from 'react';
import {
  Select as MuiSelect,
  MenuItem as MuiMenuItem,
  SelectProps as MuiSelectProps,
  InputLabel,
  Box,
} from '@mui/material';

export type SelectProps = MuiSelectProps & {
  inputLabel: string;
  children: any;
};

export const Select = ({ inputLabel, children, ...props }: SelectProps) => {
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
        sx={{ width: '100%', mt: 0.5, ...props.sx }}
      >
        <MuiMenuItem value="">
          <em>All {inputLabel}</em>
        </MuiMenuItem>
        {children}
      </MuiSelect>
    </Box>
  );
};
