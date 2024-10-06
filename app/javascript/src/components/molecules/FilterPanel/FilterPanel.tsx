import { Grid, Box, Typography, Button } from "@mui/material"
import React from "react"


interface FilterPanelProps {

}

export const FilterPanel = ({} : FilterPanelProps) => {

    return (
        <Grid item xs={12} md={3}>
        <Box sx={{ border: '1px solid #e0e0e0', borderRadius: '8px', p: 2 }}>
          <Typography variant="h6">Filters</Typography>
          {/* Placeholder filter buttons */}
          <Box sx={{ mt: 2 }}>
            <Typography variant="body1">Location</Typography>
            <Button variant="outlined" fullWidth sx={{ my: 1 }}>United States</Button>
          </Box>
          <Box sx={{ mt: 2 }}>
            <Typography variant="body1">Job Type</Typography>
            <Button variant="outlined" fullWidth sx={{ my: 1 }}>Full-time</Button>
            <Button variant="outlined" fullWidth sx={{ my: 1 }}>Part-time</Button>
          </Box>
          <Box sx={{ mt: 2 }}>
            <Typography variant="body1">Remote</Typography>
            <Button variant="outlined" fullWidth sx={{ my: 1 }}>Remote</Button>
          </Box>
        </Box>
      </Grid>
    )
}