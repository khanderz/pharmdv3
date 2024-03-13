import React, { useState, useEffect, useMemo } from 'react'
import { Box, Container, Grid, Tab, Typography } from '@mui/material'
import { TabList, TabContext } from '@mui/lab'
import { TABNAMES } from './DirectoryTable.types'
import { DirectoryTable } from './DirectoryTable'
import { LicenseInfo } from '@mui/x-license-pro'
import { Company } from './Directory.types'

export const Directory = () => {
  const [key, setKey] = React.useState('')
  const REACT_MUIX_API_KEY = process.env.REACT_MUIX_API_KEY

  useMemo(() => {
    setKey(REACT_MUIX_API_KEY ?? '')
  }, [REACT_MUIX_API_KEY])
  LicenseInfo.setLicenseKey(key)

  const [state, setState] = useState<JSX.Element | null>(null)

  const [items, setItems] = useState<Company[]>([])
  console.log({ items })
  useMemo(() => {
    fetch('/companies')
      .then((response) => response.json())
      .then((data) => {
        if (data.loading) {
          setState(loadingState)
        } else if (data.length > 0) {
          setItems(data)
          setState(<DirectoryTable data={items} rows={items.length} />)
        } else if (data.catch) {
          data.catch((error: Error) => {
            const errorState = <Typography> {error.message} </Typography>
            setState(errorState)
          })
        }
      })
  }, [items])

  const loadingState = <Typography> Loading... </Typography>

  return (
    <Box>
      <Container>
        <Grid>
          <TabContext value="Companies">
            <TabList variant="fullWidth">
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
