import React from "react";
import { Grid, Typography } from "@mui/material";

interface AttributeProps {
  label: string;
  value: string;
}

export const Attribute = ({ label, value }: AttributeProps) => {
  console.log("AttributeProps", label, value);
  return (
    <Grid container flexDirection="row">
      <Grid item>
        <Typography variant="body2">{label}:</Typography>
      </Grid>
      <Grid item>
        <Typography variant="body2">{value}</Typography>
      </Grid>
    </Grid>
  );
};
