import React from 'react';
import { Box, Typography } from '@mui/material';
import { Button } from '@components/atoms';

export interface NoMatchStateProps {
  message: string;
  onReset: () => void;
}

export const NoMatchState = ({ message, onReset }: NoMatchStateProps) => {
  return (
    <Box
      flexDirection="column"
      rowGap={2}
      sx={{
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
        height: '100%',
      }}
    >
      <Typography variant="h4" color="textSecondary" align="center">
        {message}
      </Typography>
      <Button variant="contained" color="primary" onClick={onReset}>
        Reset Filters
      </Button>
    </Box>
  );
};
