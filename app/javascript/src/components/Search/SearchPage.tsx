import React, { useState, useEffect, useMemo } from 'react'
import { Box, Container, Grid, TextField, Card, CardContent, Typography, Button, Pagination } from '@mui/material';


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
        <Container maxWidth="lg">
          {/* Search Bar */}
          <Box sx={{ mt: 4, mb: 4 }}>
            <TextField
              fullWidth
              variant="outlined"
              placeholder="Search for jobs or companies..."
            />
          </Box>
    
          <Grid container spacing={4}>
            {/* Filters Panel */}
            <Grid item xs={12} md={3}>
              <Box sx={{ border: '1px solid #e0e0e0', borderRadius: '8px', p: 2 }}>
                <Typography variant="h6">Filters</Typography>
                {/* Add Filter Categories Here */}
                <Box sx={{ mt: 2 }}>
                  <Typography variant="body1">Location</Typography>
                  {/* Placeholders for filter controls */}
                  <Button variant="outlined" fullWidth sx={{ my: 1 }}>United States</Button>
                </Box>
                <Box sx={{ mt: 2 }}>
                  <Typography variant="body1">Job Type</Typography>
                  <Button variant="outlined" fullWidth sx={{ my: 1 }}>Full-time</Button>
                  <Button variant="outlined" fullWidth sx={{ my: 1 }}>Part-time</Button>
                </Box>
                <Box sx={{ mt: 2 }}>
                  <Typography variant="body1">Remote</Typography>
                  <Button variant="outlined" fullWidth sx={{ my: 1 }}>Remote</Button>
                </Box>
                {/* Add more filter options as needed */}
              </Box>
            </Grid>
    
            {/* Job Listings */}
            <Grid item xs={12} md={9}>
              <Grid container spacing={3}>
                {[...Array(10)].map((_, index) => (
                  <Grid item xs={12} key={index}>
                    <Card variant="outlined" sx={{ p: 2 }}>
                      <CardContent>
                        <Typography variant="h6">Job Title {index + 1}</Typography>
                        <Typography variant="body2" color="text.secondary">
                          Company Name
                        </Typography>
                        <Typography variant="body2" sx={{ mt: 1 }}>
                          Location: City, State
                        </Typography>
                        <Typography variant="body2" sx={{ mt: 1 }}>
                          Job Type: Full-time / Remote
                        </Typography>
                        <Button variant="contained" color="primary" sx={{ mt: 2 }}>
                          Apply Now
                        </Button>
                      </CardContent>
                    </Card>
                  </Grid>
                ))}
              </Grid>
    
              {/* Pagination */}
              <Box sx={{ mt: 4, display: 'flex', justifyContent: 'center' }}>
                <Pagination count={10} color="primary" />
              </Box>
            </Grid>
          </Grid>
        </Container>
      );
}