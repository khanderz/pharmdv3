// import React from 'react'
// import { Company, Pharmacy, DigitalHealth } from '../types/directory_types'

// interface TableDataProps {
//   tab: 'Companies' | 'Pharmacies' | 'Digital Health'
//   data: Array<Company | Pharmacy | DigitalHealth>
//   dataAccessors: Array<string>
// }

// export interface CompanyRowProps {
//   id: number
//   companyName: string
//   companyType: string
//   companyAtsType: string
//   companySize: number
//   operatingStatus: boolean
// }

// export interface PharmacyRowProps {
//   id: number
//   companyName: string
//   pharmacyType: string
//   pharmacyDescription: string
//   pharmacyUrl: string
//   pharmacyLogo: string
// }
// export interface DigitalHealthRowProps {
//   id: number
//   companyName: string
//   digitalHealthType: string
//   digitalHealthDescription: string
//   digitalHealthUrl: string
//   digitalHealthLogo: string
// }

// export const getTableData = ({
//   tab,
//   data,
//   dataAccessors
// }: TableDataProps):
//   | Array<CompanyRowProps>
//   | Array<DigitalHealthRowProps>
//   | Array<PharmacyRowProps> => {
//   const TableData = data?.map((value: any) => {
//     const row: CompanyRowProps | PharmacyRowProps | DigitalHealthRowProps = {
//       id: value?.companyId || 0,
//       companyName: '',
//       companyType: '',
//       companyAtsType: '',
//       companySize: 0,
//       operatingStatus: false
//     }
//     dataAccessors?.forEach((key: string) => {
//       if (
//         key === 'companyName' &&
//         (tab === 'Pharmacies' || tab === 'Digital Health')
//       ) {
//         row[key] = value?.['company']?.['companyName']
//         row.id = value?.['company']?.['companyId']
//       } else {
//         ;(row as any)[key] = value[key]
//       }
//     })
//     return row
//   })

//   return TableData
// }
