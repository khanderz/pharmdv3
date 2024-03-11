// import { gql } from 'apollo-boost'
// import { client } from '../App'

// export const GET_COMPANY_NAME = gql`
//   query get_company_name($companyId: Int!) {
//     companyName(companyId: $companyId) {
//       companyName
//     }
//   }
// `

// export const fetchCompanyName = async (companyId: number) => {
//   const { data, loading } = await client.query({
//     query: GET_COMPANY_NAME,
//     variables: { companyId }
//   })
//   return { data, loading }
// }
