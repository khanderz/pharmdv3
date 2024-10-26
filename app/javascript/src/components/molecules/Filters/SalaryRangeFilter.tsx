import React from 'react';
import { Box as MuiBox, Typography, Slider, IconButton } from '@mui/material';
import ClearIcon from '@mui/icons-material/Clear';
import {
  MAX_SALARY,
  MIN_SALARY,
  useFiltersContext,
} from '@javascript/providers/FiltersProvider';
import { CurrencyFilter } from './CurrencyFilter';
import { Box } from '@components/atoms';

const currencyOptions = [
  { label: 'All currencies', value: '' },
  { label: 'United States Dollars ($)', value: 'USD' },
  { label: 'Euro (€)', value: 'EUR' },
  { label: 'British Pounds (£)', value: 'GBP' },
  { label: 'Canadian Dollars ($)', value: 'CAD' },
  { label: 'Japanese Yen (¥)', value: 'JPY' },
  { label: 'Chinese Renminbi Yuan (¥)', value: 'CNY' },
  { label: 'Singaporean Dollars (S$)', value: 'SGD' },
  { label: 'Indian Rupees (₹)', value: 'INR' },
];

export const SalaryRangeFilter = () => {
  const {
    selectedSalaryRange,
    setSelectedSalaryRange,
    selectedSalaryCurrency,
    setSelectedSalaryCurrency,
  } = useFiltersContext();

  const handleSalaryChange = (event: Event, newValue: number | number[]) => {
    console.log({ newValue });
    setSelectedSalaryRange(newValue as [number, number]);
  };

  const clearSalaryFilter = () => {
    setSelectedSalaryRange([MIN_SALARY, MAX_SALARY]);
  };

  const min = selectedSalaryRange ? selectedSalaryRange[0] : MIN_SALARY;
  const max = selectedSalaryRange ? selectedSalaryRange[1] : MAX_SALARY;
  console.log({ selectedSalaryRange });
  return (
    <Box
      sx={{
        mt: 2,
        padding: 2,
      }}
    >
      <MuiBox
        display="flex"
        justifyContent="space-between"
        alignItems="center"
        mb={2}
      >
        <Typography variant="subtitle1">Salary</Typography>
        <IconButton onClick={clearSalaryFilter} size="small">
          <ClearIcon fontSize="small" />
        </IconButton>
      </MuiBox>
      <Typography variant="subtitle2">
        ${min} - ${max}
      </Typography>
      <Slider
        value={selectedSalaryRange || [MIN_SALARY, MAX_SALARY]}
        onChange={handleSalaryChange}
        valueLabelDisplay="auto"
        min={MIN_SALARY}
        max={MAX_SALARY}
        sx={{ marginBottom: 2 }}
      />
      <CurrencyFilter />
    </Box>
  );
};
