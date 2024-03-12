import { Company } from './Directory.types'

export const TABNAMES = ['Companies']

export const TABLEHEADERS = ['Job Role', 'Department', 'Location', 'Apply']
export type tableHeaderTypes = 'Job Role' | 'Department' | 'Location' | 'Apply'

export interface Jobs {
  jobTitle: string
  jobType: string // department
  jobLocation: string
  jobUrl: string
  jobActive?: boolean
  jobId?: string
  jobInternalId?: number
  jobUpdated?: string
}
export interface TableProps {
  data: Array<Company>
  rows: number
  loading?: boolean
}
