import React from "react";
import { Grid, Typography } from "@mui/material";
import { Chip } from "@javascript/components/atoms/Chip";

interface AttributeProps {
  label: string;
  value: string | string[];
  renderChip?: boolean;
}

export const Attribute = ({
  label,
  value,
  renderChip = false,
}: AttributeProps) => {
  return (
    <Grid container flexDirection="row" columnSpacing={1} sx={{ m: 0.5 }}>
      <Grid item>
        <Typography variant="key">{label}:</Typography>
      </Grid>
      <Grid item wrap>
        {renderChip ? (
          <Chip value={value} />
        ) : (
          <Typography variant="body2">
            {Array.isArray(value) ? value.join(", ") : value}
          </Typography>
        )}
      </Grid>
    </Grid>
  );
};
