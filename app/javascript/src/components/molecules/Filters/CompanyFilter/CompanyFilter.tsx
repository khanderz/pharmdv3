import { Box, Typography, FormControl, Select, MenuItem } from "@mui/material";
import React from "react";

export interface CompanyFilterProps {
    companies: Company['company_name'][];
    selectedCompany: Company['company_name'] | null;
    onCompanyFilter: (company_name: Company['company_name'] | null) => void;
}


export const CompanyFilter = ({
    companies,
    selectedCompany,
    onCompanyFilter
}: CompanyFilterProps) => {
    return (
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
    );
};