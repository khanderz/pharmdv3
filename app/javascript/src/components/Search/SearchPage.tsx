import React, { useState, useEffect, useMemo } from 'react'
import { Box, Container, Grid, Tab, Typography } from '@mui/material'


export const SearchPage = (props: any) => {
    console.log("Props in SearchPage:", props);

    return (
        <Box>
            <Container>
                <Grid container>
                    <Grid item>
                        <Typography>Search Page</Typography>
                    </Grid>
                </Grid>
            </Container>
        </Box>
    )
}