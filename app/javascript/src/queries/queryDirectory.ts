// import { gql } from 'apollo-boost'
// import { client } from '../App'

// export const QUERY_DIRECTORY = gql`
//   query {
//     companies {
//       companyId
//       companyName
//       operatingStatus
//       companyType
//       companyAtsType
//       companySize
//     }
//     pharmacies {
//       company {
//         companyId
//         companyName
//         operatingStatus
//         companyType
//         companyAtsType
//         companySize
//       }
//       pharmacyId
//       pharmacyType
//       pharmacyLogo
//       pharmacyUrl
//       pharmacyDescription
//     }
//     digitalHealths {
//       company {
//         companyId
//         companyName
//         operatingStatus
//         companyType
//         companyAtsType
//         companySize
//       }
//       digitalHealthId
//       digitalHealthType
//       digitalHealthLogo
//       digitalHealthUrl
//       digitalHealthDescription
//     }
//   }
// `

// export const fetchData = async () => {
//   const { data, loading } = await client.query({
//     query: QUERY_DIRECTORY
//   })
//   return { data, loading }
// }
