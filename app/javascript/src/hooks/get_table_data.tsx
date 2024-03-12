import { Company } from '../components/Directory/Directory.types'

interface TableDataProps {
  tab: 'Companies'
  data: Array<Company>
  dataAccessors: Array<string>
}

export interface CompanyRowProps {
  id: number
  companyName: string
  companyType: string
  companyAtsType: string
  companySize: number
  operatingStatus: boolean
}

export const getTableData = ({
  tab,
  data,
  dataAccessors
}: TableDataProps): Array<CompanyRowProps> => {
  const TableData = data?.map((value: any) => {
    const row: CompanyRowProps = {
      id: value?.companyId || 0,
      companyName: '',
      companyType: '',
      companyAtsType: '',
      companySize: 0,
      operatingStatus: false
    }
    dataAccessors?.forEach((key: string) => {
      if (key === 'companyName') {
        row[key] = value?.['company']?.['companyName']
        row.id = value?.['company']?.['companyId']
      } else {
        ;(row as any)[key] = value[key]
      }
    })
    return row
  })

  return TableData
}
