import React from "react";
import { Grid, Typography } from "@mui/material";

interface AttributeProps {
  label: string;
  value: string;
}

export const Attribute = ({ label, value }: AttributeProps) => {
  return (
    <Grid container flexDirection="row" columnSpacing={1} sx={{ m: 0.5 }}>
      <Grid item>
        <Typography variant="key">{label}:</Typography>
      </Grid>
      <Grid item>
        <Typography variant="body2">{value}</Typography>
      </Grid>
    </Grid>
  );
};
