import React from "react";
import { Box as MuiBox, Typography, Slider, IconButton } from "@mui/material";
import ClearIcon from "@mui/icons-material/Clear";
import {
  MAX_SALARY,
  MIN_SALARY,
  useFiltersContext,
} from "@javascript/providers/FiltersProvider";
import { CurrencyFilter } from "./CurrencyFilter";
import { Box } from "@components/atoms";

const currencySymbols: { [key: string]: string } = {
  USD: "$",
  EUR: "€",
  GBP: "£",
  CAD: "$",
  JPY: "¥",
  CNY: "¥",
  SGD: "S$",
  INR: "₹",
  AUD: "A$",
  BRL: "R$",
  CHF: "CHF",
  KRW: "₩",
  NZD: "NZ$",
  SEK: "kr",
  ZAR: "R",
};

export const SalaryRangeFilter = () => {
  const {
    selectedSalaryRange,
    setSelectedSalaryRange,
    selectedSalaryCurrency,
  } = useFiltersContext();

  const handleSalaryChange = (event: Event, newValue: number | number[]) => {
    setSelectedSalaryRange(newValue as [number, number]);
  };

  const clearSalaryFilter = () => {
    setSelectedSalaryRange([MIN_SALARY, MAX_SALARY]);
  };

  const selectedCurrency = selectedSalaryCurrency?.label || "USD";
  const currencySymbol = currencySymbols[selectedCurrency] || "$";
  const min = selectedSalaryRange ? selectedSalaryRange[0] : MIN_SALARY;
  const max = selectedSalaryRange ? selectedSalaryRange[1] : MAX_SALARY;

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
        {currencySymbol}
        {min} - {currencySymbol}
        {max}
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
