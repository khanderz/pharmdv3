import React from 'react';
import { Box, Typography } from '@mui/material';

export interface ErrorStateProps {
  errors: string | null;
}

export const ErrorState = ({ errors }: ErrorStateProps) => (
  <Box
    sx={{
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      height: '100vh',
      width: '100vw',
    }}
  >
    <Typography color="error.main" variant="h4" align="center">
      Error loading data: {errors}
    </Typography>
  </Box>
);
