import React from "react"
import { TextField, Box } from "@mui/material"

interface SearchPanelProps { }


export const SearchPanel = ({ }: SearchPanelProps) => {


  return (
    <Box sx={{
      mt: 3, mb: 4, border: '1px solid #66c1aa',
      borderRadius: '2px',
    }} data-testid="search-panel">
      <TextField
        fullWidth
        variant="outlined"
        placeholder="Search for jobs or companies..."
      />
    </Box>
  )
}