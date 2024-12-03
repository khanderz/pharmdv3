import React, { useState, useEffect, useMemo } from 'react';
import { Box, Tab, Typography } from '@mui/material';
import { TabList, TabContext } from '@mui/lab';
import { TABNAMES } from './DirectoryTable.types';
import { DirectoryTable } from './DirectoryTable';
import { LicenseInfo } from '@mui/x-license-pro';
import { Company } from './Directory.types';
import { useApiKey } from '../../../hooks/get_api_var';
import { useCompanies } from '../../../hooks/get_companies';
import { Container } from '@components/atoms/Paper';

export const Directory = () => {
  const { key } = useApiKey();

  useEffect(() => {
    if (key) {
      LicenseInfo.setLicenseKey(key);
    }
  }, [key]);

  const { companies, loading, error } = useCompanies();
  console.log({ companies });
  // useEffect(() => {
  //   setCompanies(companiesData);
  //   setLoading(loadingReturn);
  //   setError(errorReturn);
  // }, [companiesData, loadingReturn, errorReturn]);

  if (loading) {
    return <Typography>Loading...</Typography>;
  }

  if (error) {
    return <Typography>Error: {error.message}</Typography>;
  }

  return (
    <Container dataTestId="directory">
      <Box
        sx={{
          justifySelf: 'flex-start',
          alignSelf: 'flex-start',
          width: '100%',
          mt: 2,
        }}
      >
        {companies?.length === 0 ? (
          <Typography>No companies found.</Typography>
        ) : (
          <DirectoryTable data={companies} rows={companies?.length} />
        )}
      </Box>
    </Container>
  );
};
