import { useState, useEffect } from 'react';
import { Adjudication } from '../adjudication.types';

const [departments, setDepartments] = useState<string[]>([]);

useEffect(() => {
  const fetchDepartments = async () => {
    try {
      const response = await fetch('/departments.json');
      if (!response.ok) {
        throw new Error(`Error fetching departments: ${response.status}`);
      }
      const data = await response.json();
      setDepartments(data);
    } catch (error) {
      console.error(error);
    }
  };

  fetchDepartments();
}, []);

export type Departments = (typeof departments)[number];

export interface Department {
  id: number;
  dept_name: Departments;

  error_details: Adjudication['error_details'];
  reference_id: Adjudication['adjudicatable_id'];
  resolved: Adjudication['resolved'];
}
