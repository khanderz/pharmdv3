export interface GreenhouseJob {
  absolute_url: string
  id: number
  internal_job_id: number
  location: {
    name: string
  }
  title: string
  updated_at: string
}

export interface GreenhouseDepartment {
  id: number
  name: string
  jobs: GreenhouseJob[]
}
