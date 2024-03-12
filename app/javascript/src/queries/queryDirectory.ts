import { gql } from 'apollo-boost'
import { client } from '../App'

export const QUERY_DIRECTORY = gql`
  query {
    companies {
      companyId
      companyName
      operatingStatus
      companyType
      companyAtsType
      companySize
    }
  }
`

export const fetchData = async () => {
  const { data, loading } = await client.query({
    query: QUERY_DIRECTORY
  })
  return { data, loading }
}
