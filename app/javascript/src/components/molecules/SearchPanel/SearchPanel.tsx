import React from "react";
import { TextField } from "@mui/material";
import { Box } from "@components/atoms";
import { useFiltersContext } from "@javascript/providers/FiltersProvider";

export const SearchPanel = () => {
  const { searchQuery, setSearchQuery } = useFiltersContext();

  const handleSearchChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSearchQuery(event.target.value);
  };

  return (
    <Box
      sx={{
        border: "2px solid #000000",
        boxShadow: "3px 3px 0px 0px #000000",
        borderRadius: "2px",
      }}
      data-testid="search-panel"
    >
      <TextField
        fullWidth
        variant="outlined"
        placeholder="Search for jobs or companies..."
        value={searchQuery}
        onChange={handleSearchChange}
      />
    </Box>
  );
};
