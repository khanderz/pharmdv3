import { useState, useEffect } from 'react';
import { Company } from '@customtypes/company';

const test_companies = [
  {
    company_name: 'Tech Innovators Inc',
    operating_status: true,
    ats_type_id: 1,
    company_size_id: 2,
    funding_type_id: 3,
    linkedin_url: 'https://linkedin.com/company/tech-innovators-inc',
    company_url: 'https://www.techinnovators.com',
    company_type_id: 1,
    year_founded: 2010,
    acquired_by: null,
    company_description:
      'A leading provider of innovative technology solutions for healthcare and finance industries.',
    ats_id: 'ATS12345',
    logo_url: 'https://www.techinnovators.com/logo.png',
    company_tagline: 'Innovating the Future',
    is_completely_remote: false,
    error_details: null,
    reference_id: 1001,
    resolved: true,
    created_at: '2024-12-03T12:00:00Z',
    updated_at: '2024-12-03T12:00:00Z',
  },
  {
    company_name: 'Green Solutions',
    operating_status: true,
    ats_type_id: 2,
    company_size_id: 3,
    funding_type_id: 1,
    linkedin_url: 'https://linkedin.com/company/green-solutions',
    company_url: 'https://www.greensolutions.com',
    company_type_id: 2,
    year_founded: 2015,
    acquired_by: null,
    company_description:
      'Pioneering sustainable solutions for the energy and agriculture sectors.',
    ats_id: 'ATS54321',
    logo_url: 'https://www.greensolutions.com/logo.png',
    company_tagline: 'Sustainability at Its Best',
    is_completely_remote: true,
    error_details: null,
    reference_id: 1002,
    resolved: true,
    created_at: '2024-12-03T12:00:00Z',
    updated_at: '2024-12-03T12:00:00Z',
  },
  {
    company_name: 'Wellness First',
    operating_status: true,
    ats_type_id: 3,
    company_size_id: 1,
    funding_type_id: 2,
    linkedin_url: 'https://linkedin.com/company/wellness-first',
    company_url: 'https://www.wellnessfirst.com',
    company_type_id: 3,
    year_founded: 2020,
    acquired_by: 'Healthy Living Group',
    company_description:
      'A digital health company providing wellness and fitness solutions globally.',
    ats_id: 'ATS67890',
    logo_url: 'https://www.wellnessfirst.com/logo.png',
    company_tagline: 'Your Health, Our Priority',
    is_completely_remote: false,
    error_details: 'Minor delay in ATS integration',
    reference_id: 1003,
    resolved: false,
    created_at: '2024-12-03T12:00:00Z',
    updated_at: '2024-12-03T12:00:00Z',
  },
];

export const useCompanies = () => {
  const [companies, setCompanies] = useState<Company[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchCompanies = async () => {
      try {
        setLoading(true);
        setError(null);

        setTimeout(() => {
          setCompanies(test_companies);
          setLoading(false);
        }, 500);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : 'An unknown error occurred'
        );
        setLoading(false);
      }
    };

    fetchCompanies();
  }, []);

  // useEffect(() => {
  //   const fetchCompanies = async () => {
  //     try {
  //       setLoading(true);
  //       setError(null);

  //       const response = await fetch('/companies.json');
  //       if (!response.ok) {
  //         throw new Error(`Error fetching companies: ${response.status}`);
  //       }

  //       const data = await response.json();
  //       setCompanies(data);
  //     } catch (err) {
  //       setError(
  //         err instanceof Error ? err.message : 'An unknown error occurred'
  //       );
  //     } finally {
  //       setLoading(false);
  //     }
  //   };

  //   fetchCompanies();
  // }, []);
  console.log({ companies });
  return { companies, loading, error };
};
