import React, { useState } from 'react';
import {
  Typography,
  AccordionDetails,
  AccordionSummary,
  Box,
  Grid,
  IconButton,
} from '@mui/material';
import { FilterList } from '@mui/icons-material';
import {
  CompanyFilter,
  DomainFilter,
  DepartmentFilter,
  SpecialtyFilter,
  JobRoleFilter,
  JobSettingFilter,
  JobCommitmentFilter,
  CompanySizeFilter
} from '@components/molecules/Filters';
import { SearchPanel } from '@components/molecules/SearchPanel/SearchPanel';
import { Accordion } from '@components/atoms/Accordion';
import { Button } from '@components/atoms';
import { DateFilter } from '@components/molecules/Filters/DateFilter';

interface FilterPanelProps {
  resetFilters: () => void;
}

export const FilterPanel = ({ resetFilters }: FilterPanelProps) => {
  const [isExpanded, setExpanded] = useState(true);

  const toggleAccordion = () => {
    setExpanded(!isExpanded);
  };

  return (
    <Accordion expanded={isExpanded} componentName="filter-panel">
      <AccordionSummary
        aria-controls="more-filters-content"
        id="more-filters-header"
        sx={{
          '&.MuiButtonBase-root, & .MuiAccordionSummary-root, & .MuiAccordionSummary-content':
            {
              cursor: 'default',
            },
          '&.Mui-focused, &:focus, &:hover, &.Mui-focusVisible': {
            backgroundColor: 'transparent',
          },
        }}
      >
        <Box
          data-testid="non-expanded-filters"
          flexDirection="column"
          rowGap={2}
          sx={{
            display: 'flex',
            width: '100%',
          }}
        >
          <Box
            flexDirection="row"
            sx={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
            }}
          >
            <Typography variant="h5">Filters</Typography>
            <Box
              flexDirection="row"
              sx={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
              }}
            >
              <Button
                data-testid={`filter-panel-reset-button`}
                variant="contained"
                color="secondary"
                sx={{ m: 2, float: 'right' }}
                onClick={() => {
                  resetFilters();
                  // setExpanded(false);
                }}
              >
                Reset
              </Button>
              <IconButton
                onClick={toggleAccordion}
                sx={{ color: 'primary.main' }}
              >
                <FilterList />
              </IconButton>
            </Box>
          </Box>

          <SearchPanel />
          <Grid
            container
            direction="row"
            justifyContent="space-around"
            alignItems="center"
            columnSpacing={2}
          >
            <Grid item xs={5}>
              <CompanyFilter />
            </Grid>

            <Grid item xs={5}>
              <DomainFilter />
            </Grid>

            <Grid item xs={2}>
              <JobSettingFilter expanded={isExpanded} />
            </Grid>
          </Grid>
        </Box>
      </AccordionSummary>
      <Box role="presentation" data-testid="expanded-filters">
        <AccordionDetails>
          <Grid container spacing={2}>
            <Grid container item xs={6} direction="column">
              <SpecialtyFilter />

              <DepartmentFilter />

              <JobRoleFilter />
            </Grid>
            <Grid container item xs={6} direction="column">
              <JobCommitmentFilter />

              <DateFilter />

              <CompanySizeFilter />
            </Grid>
          </Grid>
        </AccordionDetails>
      </Box>
    </Accordion>
  );
};
