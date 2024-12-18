import React, { useState, useEffect } from 'react';
import {
  DataGridPro,
  GridRowParams,
  MuiEvent,
  useGridApiRef,
  DataGridProProps,
} from '@mui/x-data-grid-pro';

import {
  Box,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography,
  CircularProgress,
  Grid,
} from '@mui/material';
import { TableProps } from './DirectoryTable.types';
import { getTableData } from '../../../hooks/get_table_data';
import { dataHeaders } from '../../../hooks/get_table_headers';
import { Company } from '@customtypes/company';
import axios from 'axios';

// import {
//   Jobs,
//   TABLEHEADERS,
//   tableHeaderTypes,
//   TableProps
// } from '../types/directory_table_types'
// import { fetchCompanyJobs } from '../queries/query_job_posts'
// import { Company, DigitalHealth, Pharmacy } from '../types/directory_types'

// import { JobsTable } from './JobsTable'

export const DirectoryTable = ({
  data,
  rows,
}: TableProps): React.JSX.Element => {
  const [open, setOpen] = useState(false);
  const apiRef = useGridApiRef();

  const renderDataHeaders: HeaderProps = dataHeaders({ open });
  const dataAccessors = renderDataHeaders.map((header: GridColDef) => {
    // if (header.nestedKey) {
    //   return (row: any) => {
    //     return row[header.field][header.nestedKey];
    //   };
    // }
    return (row: any) => row[header.field];
  });

  const tableData = getTableData({ data, dataAccessors });

  const handleUpdateRow = (
    params: GridRowParams,
    event: MuiEvent<React.MouseEvent>
  ) => {
    setOpen(!open);
  };

  const companyToPass = (companyId: Company['id']) => {
    const company = data.find((company) => company.id === companyId);
    console.log({ company });
    return company;
  };

  const getDetailPanelContent = React.useCallback<
    NonNullable<DataGridProProps['getDetailPanelContent']>
  >(({ id, row, columns }) => <CompanyDetailsPanel companyId={id} />, []);

  const getDetailPanelHeight = React.useCallback(() => 400, []);

  return (
    <Box>
      <DataGridPro
        rows={tableData}
        apiRef={apiRef}
        columns={renderDataHeaders}
        getRowId={(row: Company) => row.id}
        onRowClick={(
          params: GridRowParams<any>,
          event: MuiEvent<React.MouseEvent<Element, MouseEvent>>
        ) => handleUpdateRow(params, event)}
        getDetailPanelContent={getDetailPanelContent}
        getDetailPanelHeight={getDetailPanelHeight}
      />
    </Box>
  );
};

// t.string 'company_name'
// t.boolean 'operating_status'
// t.bigint 'ats_type_id', null: false
// t.bigint 'company_size_id'
// t.bigint 'funding_type_id'
// t.string 'linkedin_url'
// t.string 'company_url'
// t.bigint 'company_type_id'
// t.integer 'year_founded'
// t.string 'acquired_by'
// t.text 'company_description'
// t.string 'ats_id'
// t.string 'logo_url'
// t.string 'company_tagline'
// t.boolean 'is_completely_remote'
// company cities, countries ,states
//  company domains
// company specialties
//  company type

export const CompanyDetailsPanel = (companyId: GridRowId) => {
  const [companyData, setCompanyData] = useState<Company>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  const fetchCompanyDetails = async (id: number) => {
    try {
      setLoading(true);
      const response = await axios.get(`/companies/${companyId['companyId']}`);
      setCompanyData(response.data);
      setError(null);
    } catch (err) {
      setError('Failed to fetch company details.');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (companyId) {
      fetchCompanyDetails(companyId);
    }
  }, [companyId]);

  if (loading) {
    return (
      <Box
        sx={{
          display: 'flex',
          justifyContent: 'center',
          alignItems: 'center',
          height: 200,
        }}
      >
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Box sx={{ textAlign: 'center', color: 'red', padding: 2 }}>
        <Typography variant="h6">{error}</Typography>
      </Box>
    );
  }

  if (!companyData) {
    return (
      <Box sx={{ textAlign: 'center', padding: 2 }}>
        <Typography variant="h6">No company data available.</Typography>
      </Box>
    );
  }
  console.log({ companyData });
  //   companyData:
  // acquired_by: ""
  // ats_id: "1910genetics"
  // ats_type: {ats_type_name: 'Greenhouse'}
  // ats_type_id: 8
  // company_cities: [{…}]
  // city  :   {city_name: 'Boston'}
  // city_id  :   3
  // id: 1654
  // company_countries: [{…}]
  // company_description: "1910 Genetics is the only biotechnology company advancing small and large molecule drug discovery with a multimodal AI platform powered by laboratory automation. We integrate AI with three proprietary data streams – computational data, wet lab proxy biological data, and wet lab ground truth biological data – to deliver novel drug candidates and software solutions to leading pharma and tech partners, and advance our internal pipeline for neurological, autoimmune diseases, and cancer."
  // company_domains: (6) [{…}, {…}, {…}, {…}, {…}, {…}]
  //   company_id: 1
  // healthcare_domain: {key: 'DIGITAL_HEALTH', value: 'Digital Health'}
  // healthcare_domain_id: 5
  // id: 4578
  // company_name: "1910 genetics"
  // company_size: {size_range: '11-50'}
  // company_size_id: 2
  // company_specializations: []
  // company_states: [{…}]
  // company_tagline: "Advancing small and large molecule drug discovery with a multimodal AI platform powered by laboratory automation."
  // company_type: {}
  // company_type_id: 5
  // company_url: "http://www.1910genetics.com"
  // created_at: "2024-12-05T20:28:09.190Z"
  // error_details: null
  // funding_type_id: null
  // healthcare_domains: (6) [{…}, {…}, {…}, {…}, {…}, {…}]
  // {key: 'DIGITAL_HEALTH', value: 'Digital Health'}
  // id: 1
  // is_completely_remote: null
  // job_posts: []
  // linkedin_url: "https://www.linkedin.com/company/1910genetics"
  // logo_url: "https://na1.hubspot-logos.com/1910genetics.com"
  // operating_status: true
  // reference_id: null
  // resolved: null
  // updated_at: "2024-12-06T15:31:49.882Z"
  // year_founded: 2018

  return (
    <Box sx={{ height: 400, width: '100%' }}>
      <Grid container>
        <Typography variant="h6">{companyData.company_name}</Typography>
        <Typography variant="body1">
          Description: {companyData.company_description}
        </Typography>
        <Typography variant="body1">
          Size: {companyData.company_size?.size_range || 'N/A'}
        </Typography>
        <Typography variant="body1">
          Founded: {companyData.year_founded || 'N/A'}
        </Typography>
        <Typography variant="body1">
          Location:{' '}
          {`${companyData.city?.city_name || ''}, ${companyData.state?.state_name || ''}, ${companyData.country?.country_name || ''}`}
        </Typography>

        <Box sx={{ marginTop: 2 }}>
          <Typography variant="h6">Job Posts</Typography>
          <ul key={companyData.id}>
            {companyData.job_posts?.map((job: any) => (
              <li key={job.id}>
                {job.job_title} - {job.job_description} (
                {job.job_active ? 'Active' : 'Inactive'})
              </li>
            ))}
          </ul>
        </Box>
      </Grid>
    </Box>
  );
};
