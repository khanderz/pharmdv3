import React, { useState, useEffect, useMemo } from 'react'
import { Box, Container, Grid, Tab, Typography } from '@mui/material'


export const SearchPage = ( ) => {
    const [companies, setCompanies] = useState([]);
    const [jobPosts, setJobPosts] = useState([]);

    useEffect(() => {
      const fetchCompanies = async () => {
        try {
          const response = await fetch('/companies.json');
          const data = await response.json();
          setCompanies(data);
        } catch (error) {
          console.error("Error fetching companies:", error);
        }
      };
  
      fetchCompanies();
    }, []);

    useEffect(() => {
        const fetchJobPosts = async () => {
          try {
            const response = await fetch('/job_posts.json');
            const data = await response.json();
            setJobPosts(data);
          } catch (error) {
            console.error('Error fetching job posts:', error);
          }
        };
        fetchJobPosts();
      }, []);
    
      console.log({ companies, jobPosts });
      
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