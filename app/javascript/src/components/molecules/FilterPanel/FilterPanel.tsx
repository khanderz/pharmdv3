import React from "react";
import { Box, Typography, Select, MenuItem, Button, FormControl, InputLabel } from "@mui/material";
import { Company } from "../../../types/company.types";

interface FilterPanelProps {
  companies: Company['company_name'][];
  selectedCompany: Company['company_name'] | null;
  onCompanyFilter: (company_name: Company['company_name'] | null) => void;
}

export const FilterPanel = ({ companies, selectedCompany, onCompanyFilter }: FilterPanelProps) => {
  return (
    <Box sx={{ border: '1px solid #e0e0e0', borderRadius: '8px', p: 2 }}>
      <Typography variant="h6">Filters</Typography>

      {/* Company Filter */}
      <Box sx={{ mt: 2 }}>
        <Typography variant="body1" sx={{ mb: 1 }}>Company</Typography>
        <FormControl fullWidth>
          <Select
            value={selectedCompany || ""}
            onChange={(e) => onCompanyFilter(e.target.value || null)}
            displayEmpty
          >
            <MenuItem value="">
              <em>All Companies</em>
            </MenuItem>
            {companies.map((company, index) => (
              <MenuItem key={index} value={company}>
                {company}
              </MenuItem>
            ))}
          </Select>
        </FormControl>
      </Box>

      <Box sx={{ mt: 2 }}>
        <Typography variant="body1">Location</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          United States
        </Button>
      </Box>

      <Box sx={{ mt: 2 }}>
        <Typography variant="body1">Job Type</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Full-time
        </Button>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Part-time
        </Button>
      </Box>

      <Box sx={{ mt: 2 }}>
        <Typography variant="body1">Remote</Typography>
        <Button variant="outlined" fullWidth sx={{ my: 1 }}>
          Remote
        </Button>
      </Box>
    </Box>
  );
};
