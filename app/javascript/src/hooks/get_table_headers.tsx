import { GridCellParams, GridColDef } from '@mui/x-data-grid';
import React from 'react';
import { KeyboardArrowUp, KeyboardArrowDown } from '@mui/icons-material';

interface TableHeaderProps {
  open: boolean;
}
export const dataHeaders = ({ open }: TableHeaderProps): GridColDef[] => {
  type GridNativeColTypes =
    | 'string'
    | 'number'
    | 'date'
    | 'dateTime'
    | 'boolean'
    | 'singleSelect';

  type GridAlignment = 'left' | 'right' | 'center';

  return [
    {
      headerName: 'Open Jobs',
      field: 'openJobs',
      flex: 0.5,
      type: 'singleSelect',
      headerAlign: 'center' as GridAlignment,
      align: 'center',
      renderCell: (params: GridCellParams) =>
        open ? <KeyboardArrowUp /> : <KeyboardArrowDown />,
      // valueGetter: (params: GridValueGetterParams) =>
      // `${params.row.firstName || ""} ${params.row.lastName || ""}`,
    },
    {
      headerName: 'Company Name',
      field: 'companyName',
      flex: 1,
      type: 'string',
      headerAlign: 'center' as GridAlignment,
      align: 'center',
    },
    {
      headerName: 'Company Type',
      field: 'companyType',
      flex: 1,
      type: 'string',
      headerAlign: 'center' as GridAlignment,
      align: 'center',
    },
    // {
    //   headerName: 'Company ATS Type',
    //   field: 'companyAtsType',
    //   flex: 1,
    //   type: 'string',
    //   headerAlign: 'center' as GridAlignment,
    //   align: 'center',
    // },
    {
      headerName: 'Company Size',
      field: 'companySize',
      flex: 1,
      type: 'number',
      headerAlign: 'center' as GridAlignment,
      align: 'center',
    },
    {
      headerName: 'Company Active',
      field: 'operatingStatus',
      flex: 1,
      type: 'boolean',
      headerAlign: 'center' as GridAlignment,
      align: 'center',
    },
  ];
};
