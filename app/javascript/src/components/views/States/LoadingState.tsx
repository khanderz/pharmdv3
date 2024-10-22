import React from 'react';
import { Box, Typography, CircularProgress } from '@mui/material';

export interface LoadingStateProps {}

export const LoadingState = () => (
  <Box
    sx={{
      display: 'flex',
      justifyContent: 'center',
      alignItems: 'center',
      flexDirection: 'column',
      height: '100vh',
      width: '100vw',
    }}
  >
    <Typography variant="h4" align="center" color="primary.main" sx={{ my: 4 }}>
      Loading...
    </Typography>
    <CircularProgress />
  </Box>
);
