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
  console.log({ inputLabel });
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
        value={props.multiple ? (props.value ?? []) : (props.value ?? '')}
        onChange={props.onChange}
        displayEmpty
        label={inputLabel}
        renderValue={(selected) => {
          if ((selected as []).length === 0) {
            return <em>All {inputLabel}</em>;
          }
          return (selected as string[]).join(', ');
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
