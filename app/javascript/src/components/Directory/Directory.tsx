import React, { useState, useEffect } from 'react'
import { Box, Container, Grid, Tab, Typography } from '@mui/material'
import { TabList, TabContext } from '@mui/lab'
import { TABNAMES, TableProps } from './DirectoryTable.types'
import { fetchData } from '../../queries/queryDirectory'
// import { DirectoryTable } from '../components/DirectoryTable'

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
const tablePropsToPass = (companyTypeFilter: TableProps['tab']): string => {
  if (companyTypeFilter === 'Companies') {
    return 'companies'
  }
  if (companyTypeFilter === 'Pharmacies') {
    return 'pharmacies'
  }
  if (companyTypeFilter === 'Digital Health') {
    return 'digitalHealths'
  }
}

export const Directory = () => {
  const [state, setState] = useState<JSX.Element | null>(null)
  const [companyTypeFilter, setCompanyTypeFilter] =
    useState<TableProps['tab']>('Companies')

  const loadingState = <Typography> Loading... </Typography>

  const data = fetchData()

  const handleChange = (
    event: React.SyntheticEvent,
    newValue: TableProps['tab']
  ) => {
    setCompanyTypeFilter(newValue)
  }
  useEffect(() => {
    data?.then((data: any) => {
      if (data.loading) {
        setState(loadingState)
      } else if (data?.data.companies) {
        setState(null)
        //   <DirectoryTable
        //     data={data?.data[tablePropsToPass(companyTypeFilter)]}
        //     rows={data?.data[tablePropsToPass(companyTypeFilter)].length}
        //     tab={companyTypeFilter}
        //   />
      }
    })

    data.catch((error) => {
      const errorState = <Typography> {error.message} </Typography>
      setState(errorState)
    })
  }, [companyTypeFilter])

  return (
    <Box>
      <Container>
        <Grid>
          <TabContext value={companyTypeFilter}>
            <TabList onChange={handleChange} variant="fullWidth">
              {TABNAMES.map((name) => (
                <Tab label={name} value={name} key={name} />
              ))}
            </TabList>
          </TabContext>
          {state}
        </Grid>
      </Container>
    </Box>
  )
}
