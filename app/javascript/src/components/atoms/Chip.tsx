import React from "react";
import {
  ListItem,
  Chip as MuiChip,
  ChipProps as MuiChipProps,
} from "@mui/material";

export interface ChipProps extends MuiChipProps {}

export const Chip = ({ value, variant = "outlined" }: ChipProps) => {
  const values = Array.isArray(value) ? value : [value];

  return (
    <ListItem data-testid={`${value}-list-item`}>
      {values.map((val, index) => (
        <MuiChip
          data-testid={`${value}-chip`}
          key={index}
          label={val}
          variant={variant}
          sx={{ mx: 0.5 }}
        />
      ))}
    </ListItem>
  );
};
