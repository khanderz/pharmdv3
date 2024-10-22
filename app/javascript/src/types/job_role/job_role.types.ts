import { useState, useEffect } from 'react';
import { Adjudicated } from '../adjudication.types';

const [jobRoles, setJobRoles] = useState<
  {
    job_role_id: number;
    job_role_name: string[];
  }[]
>([]);

useEffect(() => {
  const fetchJobRoles = async () => {
    try {
      const response = await fetch('/job_roles.json');
      if (!response.ok) {
        throw new Error(`Error fetching job roles: ${response.status}`);
      }
      const data = await response.json();
      setJobRoles(data);
    } catch (error) {
      console.error(error);
    }
  };

  fetchJobRoles();
}, []);

export type JobRoles = (typeof jobRoles)[number];

export interface JobRole extends Adjudicated {
  job_role_id: number;
  job_role_name: JobRoles;
}
