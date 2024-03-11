// import { gql } from 'apollo-boost'
// import { GridRowId } from '@mui/x-data-grid-premium'
// import { client } from '../App'

// export const GET_COMPANY_JOBS = gql`
//   query get_company_jobs($companyId: Int!) {
//     companyJobs(companyId: $companyId) {
//       jobId
//       jobTitle
//       jobDescription
//       jobUrl
//       jobLocation
//       jobDept
//       jobPosted
//       jobUpdated
//       jobActive
//       jobInternalId
//       jobInternalIdString
//     }
//   }
// `

// export const fetchCompanyJobs = async (companyId: GridRowId) => {
//   const { data, loading } = await client.query({
//     query: GET_COMPANY_JOBS,
//     variables: { companyId }
//   })
//   return { data, loading }
// }
