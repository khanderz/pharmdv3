import React, { useState, useEffect, useMemo } from 'react'
import { Box, Container, Grid, Tab, Typography } from '@mui/material'
import { TabList, TabContext } from '@mui/lab'
import { TABNAMES } from './DirectoryTable.types'
import { DirectoryTable } from './DirectoryTable'
import { LicenseInfo } from '@mui/x-license-pro'
import { Company } from './Directory.types'
import { useApiKey } from  '../../hooks/get_api_var'

export const Directory = () => {
  const { key,  } = useApiKey();
 
 
  useEffect(() => {
    if (key) {
      LicenseInfo.setLicenseKey(key);
    }
  }, [key]);

  const [state, setState] = useState<JSX.Element | null>(null)

  const [items, setItems] = useState<Company[]>([])

  const fetchItems = async () => {
    const response = await fetch('/companies')
    const newItems = await response.json()

    if (newItems.loading) {
      setState(loadingState)
    }

    if (newItems.length > 0) {
      setItems(newItems)
    }

    if (newItems.catch) {
      newItems.catch((error: Error) => {
        const errorState = <Typography> {error.message} </Typography>
        setState(errorState)
      })
    }
  }

  useMemo(() => {
    fetchItems()
  }, [])

  useEffect(() => {
    setState(<DirectoryTable data={items} rows={items.length} />)
  }, [items])
  // useEffect(() => {
  //   const interval = setInterval(() => {
  //     fetchItems()
  //   }, 1000)

  //   return () => clearInterval(interval)
  // }, [items])

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
