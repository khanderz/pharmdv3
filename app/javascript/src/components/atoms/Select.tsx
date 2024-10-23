import React from 'react';
import {
  Select as MuiSelect,
  MenuItem as MuiMenuItem,
  SelectProps as MuiSelectProps,
  InputLabel,
  Box,
  Typography,
  Divider,
} from '@mui/material';
import { Button } from './Button';

export type SelectProps = MuiSelectProps & {
  inputLabel: string;
  children: any;
  onReset?: () => void;
};

export const Select = ({
  inputLabel,
  children,
  onReset,
  ...props
}: SelectProps) => {
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
          if (Array.isArray(selected) && selected.length === 0) {
            return <em>All {inputLabel}</em>;
          }

          if (Array.isArray(selected)) {
            return selected.join(', ');
          }

          if (selected === '' || selected === null || selected === undefined) {
            return <em>All {inputLabel}</em>;
          }

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
        <Divider />
        <Button
          data-testid={`${inputLabel}-reset-button`}
          variant="contained"
          color="secondary"
          sx={{ mt: 1, mx: 2, mb: 2, float: 'right' }}
          onClick={onReset}
        >
          Reset
        </Button>
      </MuiSelect>
    </Box>
  );
};
