// import { GridCellParams, GridColDef } from '@mui/x-data-grid'
// import React from 'react'
// import KeyboardArrowUpIcon from '@mui/icons-material/KeyboardArrowUp'
// import KeyboardArrowDownIcon from '@mui/icons-material/KeyboardArrowDown'
// import { TableProps } from '../types/directory_table_types'

// interface TableHeaderProps {
//   tab: TableProps['tab']
//   open: boolean
// }
// export const dataHeaders = ({ tab, open }: TableHeaderProps): GridColDef[] => {
//   type GridNativeColTypes =
//     | 'string'
//     | 'number'
//     | 'date'
//     | 'dateTime'
//     | 'boolean'
//     | 'singleSelect'

//   type GridAlignment = 'left' | 'right' | 'center'

//   if (tab === 'Companies') {
//     return [
//       // {
//       //   headerName: "Open Jobs",
//       //   field: "openJobs",
//       //   flex: 0.5,
//       //   type: "singleSelect",
//       //   headerAlign: "center" as GridAlignment,
//       //   align: "center",
//       //   renderCell: (params: GridCellParams) =>
//       //     open ? <KeyboardArrowUpIcon /> : <KeyboardArrowDownIcon />,
//       //   // valueGetter: (params: GridValueGetterParams) =>
//       //   // `${params.row.firstName || ""} ${params.row.lastName || ""}`,
//       // },
//       {
//         headerName: 'Company Name',
//         field: 'companyName',
//         flex: 1,
//         type: 'string',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Company Type',
//         field: 'companyType',
//         flex: 1,
//         type: 'string',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Company ATS Type',
//         field: 'companyAtsType',
//         flex: 1,
//         type: 'string',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Company Size',
//         field: 'companySize',
//         flex: 1,
//         type: 'number',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Company Active',
//         field: 'companyActive',
//         flex: 1,
//         type: 'boolean',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       }
//     ]
//   }
//   if (tab === 'Pharmacies') {
//     return [
//       {
//         headerName: 'Company Name',
//         field: 'companyName',
//         flex: 1,
//         type: 'string',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Pharmacy Type',
//         field: 'pharmacyType',
//         flex: 1,
//         type: 'string',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Pharmacy Description',
//         field: 'pharmacyDescription',
//         flex: 1,
//         type: 'string',
//         sortable: false,
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },

//       {
//         headerName: 'Pharmacy URL',
//         field: 'pharmacyUrl',
//         flex: 1,
//         type: 'string',
//         sortable: false,
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Pharmacy Logo',
//         field: 'pharmacyLogo',
//         flex: 1,
//         type: 'string',
//         sortable: false,
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       }
//     ]
//   }
//   if (tab === 'Digital Health') {
//     return [
//       {
//         headerName: 'Company Name',
//         field: 'companyName',
//         flex: 1,
//         type: 'string',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Digital Health Type',
//         field: 'digitalHealthType',
//         flex: 1,
//         type: 'string',
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Digital Health Description',
//         field: 'digitalHealthDescription',
//         flex: 1,
//         type: 'string',
//         sortable: false,
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Digital Health URL',
//         field: 'digitalHealthUrl',
//         flex: 1,
//         type: 'string',
//         sortable: false,
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       },
//       {
//         headerName: 'Digital Health Logo',
//         field: 'digitalHealthLogo',
//         flex: 1,
//         type: 'string',
//         sortable: false,
//         headerAlign: 'center' as GridAlignment,
//         align: 'center'
//       }
//     ]
//   }
// }
