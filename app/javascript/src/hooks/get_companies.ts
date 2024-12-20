import { useState, useEffect } from "react";
import {
  Company,
  CompanyDomain,
  CompanyCity,
  CompanyCountry,
  CompanyState,
  CompanySpecialization,
} from "@customtypes/company";

interface FilterParams {
  domain_id?: CompanyDomain["healthcare_domain_id"];
  company_size_id?: Company["company_size_id"];
  operating_status?: Company["operating_status"];
  funding_type_id?: Company["funding_type_id"];
  year_founded?: Company["year_founded"];
  company_description?: Company["company_description"];
  company_tagline?: Company["company_tagline"];
  is_completely_remote?: Company["is_completely_remote"];
  city_id?: CompanyCity["city_id"];
  country_id?: CompanyCountry["country_id"];
  state_id?: CompanyState["state_id"];
  specialization_id?: CompanySpecialization["company_specialty_id"];
}

export const useCompanies = (filters: FilterParams = {}) => {
  const [companies, setCompanies] = useState<Company[]>([]);
  const [filteredCompanies, setFilteredCompanies] = useState<Company[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchCompanies = async () => {
      try {
        setLoading(true);
        setError(null);
        const queryParams = new URLSearchParams();
        Object.entries(filters).forEach(([key, value]) => {
          if (value !== undefined && value !== null) {
            queryParams.append(key, String(value));
          }
        });

        const url = `/companies.json${queryParams.toString() ? `?${queryParams}` : ""}`;
        const response = await fetch(url);
        if (!response.ok) {
          throw new Error(`Error fetching companies: ${response.status}`);
        }

        const data = await response.json();
        setCompanies(data);
        setFilteredCompanies(data);
      } catch (err) {
        setError(
          err instanceof Error ? err.message : "An unknown error occurred",
        );
      } finally {
        setLoading(false);
      }
    };

    fetchCompanies();
  }, []);
  return { companies, filteredCompanies, setFilteredCompanies, loading, error };
};
