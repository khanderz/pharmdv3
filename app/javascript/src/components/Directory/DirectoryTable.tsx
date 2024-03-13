import React, { useState, useEffect } from 'react'
import {
  DataGridPremium,
  GridRowParams,
  MuiEvent,
  useGridApiRef,
  DataGridPremiumProps
} from '@mui/x-data-grid-premium'
import {
  Box,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  Typography
} from '@mui/material'
import { TableProps } from './DirectoryTable.types'
import { CompanyRowProps, getTableData } from '../../hooks/get_table_data'
import { dataHeaders } from '../../hooks/get_table_headers'
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
  rows
}: TableProps): React.JSX.Element => {
  const [open, setOpen] = useState(false)
  const apiRef = useGridApiRef()

  const renderDataHeaders = dataHeaders({ open })
  const dataAccessors = renderDataHeaders.map((key: any) => key['field'])
  const tableData = getTableData({ data, dataAccessors })

  const handleUpdateRow = (
    params: GridRowParams,
    event: MuiEvent<React.MouseEvent>
  ) => {
    setOpen(!open)
  }

  //   const getDetailPanelContent = React.useCallback<
  //     NonNullable<DataGridPremiumProps['getDetailPanelContent']>
  //   >(({ id, row, columns }) => <JobsTable companyId={id} />, [])

  const getDetailPanelHeight = React.useCallback(() => 400, [])

  return (
    <Box sx={{ height: 400, width: '100%' }}>
      <DataGridPremium
        rows={tableData}
        apiRef={apiRef}
        columns={renderDataHeaders}
        getRowId={(row: CompanyRowProps) => row.id}
        onRowClick={(
          params: GridRowParams<any>,
          event: MuiEvent<React.MouseEvent<Element, MouseEvent>>
        ) => handleUpdateRow(params, event)}
        // getDetailPanelContent={getDetailPanelContent}
        getDetailPanelHeight={getDetailPanelHeight}
      />
    </Box>
  )
}
