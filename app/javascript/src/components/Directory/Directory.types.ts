export interface Company {
  companyId: number
  companyName: string
  operatingStatus: boolean
  companyType: string
  companyAtsType?: string
  companySize?: string | number
  lastFundingType?: string
  linkedinUrl?: string
  isPublic?: boolean
  yearFounded: number
  companyCity: string
  companyState: string
  companyCountry: string
  acquiredBy?: string
  atsId?: string
  createdAt: Date
  updatedAt: Date
}

export interface CompanyType {}
