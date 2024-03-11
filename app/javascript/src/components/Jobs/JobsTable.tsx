// import React, { useState } from 'react'
// import { Box, Container, Grid, Typography } from '@mui/material'
// import {
//   DataGridPremium,
//   GridColDef,
//   GridRowId,
//   GridRowParams,
//   MuiEvent,
//   useGridApiRef
// } from '@mui/x-data-grid-premium'
// // import { fetchCompanyJobs } from '../queries/query_job_posts'

// export const JobsTable = (companyId: GridRowId) => {
//   const idToPass = Number(Object.values(companyId))
//   const columns: GridColDef[] = [
//     {
//       field: 'jobTitle',
//       headerName: 'Job Role',
//       flex: 1
//     },
//     {
//       field: 'jobDept',
//       headerName: 'Department',
//       flex: 1
//     },
//     {
//       field: 'jobLocation',
//       headerName: 'Location',
//       flex: 1
//     },
//     {
//       field: 'jobUrl',
//       headerName: 'Apply',
//       flex: 1
//     }
//   ]
//   const [rows, setRows] = useState([])

//   const getRowData = async () => {
//     const { data } = await fetchCompanyJobs(idToPass)
//     console.log(data)
//     const result = data?.companyJobs?.map((company: any) => {
//       return {
//         id: company.jobId,
//         jobTitle: company.jobTitle,
//         jobDept: company.jobDept,
//         jobLocation: company.jobLocation,
//         jobUrl: company.jobUrl
//       }
//     })
//     setRows(result)
//   }

//   React.useEffect(() => {
//     getRowData()
//   }, [])

//   return (
//     <Box sx={{ height: 400, width: '100%' }}>
//       <DataGridPremium
//         rows={rows}
//         columns={columns}
//         density="compact"
//         hideFooter
//         sx={{ flex: 1 }}
//       />
//     </Box>
//   )
// }
