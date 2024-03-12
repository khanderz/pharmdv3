import React, { useState, useEffect } from 'react'
import { Box, Container, Grid, Tab, Typography } from '@mui/material'
import { TabList, TabContext } from '@mui/lab'
import { TABNAMES } from './DirectoryTable.types'
import { DirectoryTable } from './DirectoryTable'

export const Directory = () => {
  const [state, setState] = useState<JSX.Element | null>(null)

  const [items, setItems] = useState<any[]>([])

  useEffect(() => {
    fetch('/companies')
      .then((response) => response.json())
      .then((data) => {
        if (data.loading) {
          setState(loadingState)
        } else if (data) {
          setItems(data)
          setState(null)
          setState(<DirectoryTable data={data} rows={data.length} />)
        } else if (data.catch) {
          data.catch((error: Error) => {
            const errorState = <Typography> {error.message} </Typography>
            setState(errorState)
          })
        }
      })
  }, [])
  console.log(items)
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
