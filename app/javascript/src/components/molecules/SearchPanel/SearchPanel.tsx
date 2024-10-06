import { Box, TextField } from "@mui/material"
import React from "react"

interface SearchPanelProps {}


export const SearchPanel = ({} : SearchPanelProps) => {


    return (
        <Box sx={{ mt: 4, mb: 4 }}>
        <TextField
          fullWidth
          variant="outlined"
          placeholder="Search for jobs or companies..."
        />
      </Box>
    )
}