import React from 'react';
import { TextField, Box } from '@mui/material';

interface SearchPanelProps {}

export const SearchPanel = ({}: SearchPanelProps) => {
  return (
    <Box
      sx={{
        border: '2px solid #000000',
        boxShadow: '3px 3px 0px 0px #000000',
        borderRadius: '2px',
      }}
      data-testid="search-panel"
    >
      <TextField
        fullWidth
        variant="outlined"
        placeholder="Search for jobs or companies..."
      />
    </Box>
  );
};
