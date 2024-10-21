import { Card, CardContent, Typography, Button } from "@mui/material"
import React from "react"
import { Company, CompanySpecialty } from "../../../types/company.types"
import { JobPost } from "../../../types/job_post.types"
import { HealthcareDomainValue } from "../../../types/company"

interface JobCardProps {
    title: JobPost['job_title']
    company_name: Company['company_name']
    job_location: JobPost['job_location']
    job_commitment: JobPost['job_commitment']
    job_applyUrl: JobPost['job_applyUrl']
    company_specialty: CompanySpecialty['value']
    healthcare_domains: HealthcareDomainItem['value']
}


export const JobCard = ({ title, company_name, job_location, job_commitment, job_applyUrl, company_specialty }: JobCardProps) => {

    return (
        <Card variant="outlined" sx={{ p: 2 }} data-testid="job-card">
            <CardContent>
                <Typography variant="h6">{title}</Typography>
                <Typography variant="body2" color="text.secondary">
                    {company_name || "Unknown Company"}
                </Typography>
                <Typography variant="body2" sx={{ mt: 1 }}>
                    Specialty: {company_specialty ? company_specialty : "N/A"}
                </Typography>
                <Typography variant="body2" sx={{ mt: 1 }}>
                    Location: {job_location || "N/A"}
                </Typography>
                <Typography variant="body2" sx={{ mt: 1 }}>
                    Job Type: {job_commitment || "N/A"}
                </Typography>
                <Button variant="contained" color="primary" sx={{ mt: 2 }} href={job_applyUrl}>
                    Apply Now
                </Button>
            </CardContent>
        </Card>
    )
}