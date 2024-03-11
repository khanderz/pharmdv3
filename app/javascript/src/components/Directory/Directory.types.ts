export interface Company {
  companyId: number
  companyName: string
  companyActive: boolean
  companyType: string
  companyHrType: string
  companySize: number
}
export interface Pharmacy {
  company: Company
  pharmacyId: number
  pharmacyType: string
  pharmacyLogo: string
  pharmacyUrl: string
  pharmacyDescription: string
}

export interface DigitalHealth {
  company: Company
  digitalHealthId: number
  digitalHealthType: string
  digitalHealthLogo: string
  digitalHealthUrl: string
  digitalHealthDescription: string
}
