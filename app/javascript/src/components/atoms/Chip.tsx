import React from "react";
import { ListItem, Chip as MuiChip } from "@mui/material";

export interface ChipProps {
  value: string | string[];
  variant?: "outlined" | "filled";
}

export const Chip = ({ value, variant = "outlined" }: ChipProps) => {
  const values = Array.isArray(value) ? value : [value];

  return (
    <ListItem>
      {values.map((val, index) => (
        <MuiChip key={index} label={val} variant={variant} sx={{ mx: 0.5 }} />
      ))}
    </ListItem>
  );
};
