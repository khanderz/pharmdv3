export interface LeverCategories {
  commitment: string // full-time, part-time, etc.
  department: string
  location: string
  team: string
}

export interface LeverJob {
  applyUrl: string
  hostedUrl: string
  categories: LeverCategories
  id: string
  text: string // job role title
  workplaceType: string // remote, office, etc.
  salaryRange?: {
    min: number
    max: number
    interval: string
  }
}
