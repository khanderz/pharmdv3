import React, {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
} from 'react';
import {
  Company,
  CompanySize,
  CompanySpecialty,
  HealthcareDomain,
} from '@customtypes/company';
import { JobSetting, JobCommitment, JobPost } from '@customtypes/job_post';
import { Department, JobRole } from '@customtypes/job_role';
import {
  useJobPosts,
  useHealthcareDomains,
  useDepartments,
  useJobRoles,
  useJobCommitments,
  useJobSettings,
  useCities,
  useStates,
  useCountries,
  useCompanySizes,
} from '@javascript/hooks';
import dayjs from 'dayjs';

interface FiltersContextProps {
  selectedCompanies: Company[];
  setSelectedCompanies: (companies: Company[]) => void;
  selectedDomains: HealthcareDomain[];
  setSelectedDomains: (domains: HealthcareDomain[]) => void;
  selectedSpecialties: CompanySpecialty[];
  setSelectedSpecialties: (specialties: CompanySpecialty[]) => void;
  selectedDepartments: Department[];
  setSelectedDepartments: (departments: Department[]) => void;
  selectedJobRoles: JobRole[];
  setSelectedJobRoles: (jobRoles: JobRole[]) => void;
  selectedJobSettings: JobSetting[];
  setSelectedJobSettings: (jobSettings: JobSetting[]) => void;
  selectedJobCommitments: JobCommitment[];
  setSelectedJobCommitments: (jobCommitments: JobCommitment[]) => void;
  selectedDatePosted: string | null;
  setSelectedDatePosted: (datePosted: string) => void;
  selectedCompanySize: CompanySize['id'][];
  setSelectedCompanySize: (size: CompanySize['id'][]) => void; // check type assertion
  errors: string | null;
  currentlyLoading: boolean;
  uniqueCompanies: Company[];
  uniqueSpecialties: CompanySpecialty[];
  allDomains: HealthcareDomain[];
  domainsLoading: boolean;
  departments: Department[];
  departmentsLoading: boolean;
  uniqueJobRoles: JobRole[];
  jobRolesLoading: boolean;
  jobSettings: JobSetting[];
  jobSettingsLoading: boolean;
  jobCommitments: JobCommitment[];
  jobCommitmentsLoading: boolean;
  companySizes: CompanySize[];
  companySizesLoading: boolean;
  companySizesError: string | null;
  filteredJobPosts: JobPost[];
  resetFilters: () => void;
  noMatchingResults: boolean;
  getNoResultsMessage?: () => string;
}

export const FiltersContext = createContext<FiltersContextProps>({
  selectedCompanies: [],
  setSelectedCompanies: () => {},
  selectedDomains: [],
  setSelectedDomains: () => {},
  selectedSpecialties: [],
  setSelectedSpecialties: () => {},
  selectedDepartments: [],
  setSelectedDepartments: () => {},
  selectedJobRoles: [],
  setSelectedJobRoles: () => {},
  selectedJobSettings: [],
  setSelectedJobSettings: () => {},
  selectedJobCommitments: [],
  setSelectedJobCommitments: () => {},
  selectedDatePosted: '',
  setSelectedDatePosted: () => {},
  selectedCompanySize: [],
  setSelectedCompanySize: () => {},
  errors: null,
  currentlyLoading: false,
  uniqueCompanies: [],
  uniqueSpecialties: [],
  allDomains: [],
  domainsLoading: false,
  departments: [],
  departmentsLoading: false,
  uniqueJobRoles: [],
  jobRolesLoading: false,
  jobSettings: [],
  jobSettingsLoading: false,
  jobCommitments: [],
  jobCommitmentsLoading: false,
  companySizes: [],
  companySizesLoading: false,
  companySizesError: null,
  filteredJobPosts: [],
  resetFilters: () => {},
  noMatchingResults: false,
  getNoResultsMessage: () => '',
} as FiltersContextProps);

interface FiltersProviderProps {
  children: React.ReactNode;
}

export function FiltersProvider({ children }: FiltersProviderProps) {
  const [selectedDomains, setSelectedDomains] = useState<HealthcareDomain[]>(
    []
  );

  const domainIds = useMemo(() => {
    return selectedDomains.length > 0
      ? selectedDomains.map((domain) => domain.id)
      : null;
  }, [selectedDomains]);

  /* --------------------- Hooks --------------------- */

  const { jobPosts, filteredJobPosts, setFilteredJobPosts, loading, error } =
    useJobPosts(domainIds);

  const {
    allDomains,
    loading: domainsLoading,
    error: domainsError,
  } = useHealthcareDomains();

  const {
    departments,
    loading: departmentsLoading,
    error: departmentsError,
  } = useDepartments();

  const {
    jobRoles,
    loading: jobRolesLoading,
    error: jobRolesError,
  } = useJobRoles();

  const {
    jobCommitments,
    loading: jobCommitmentsLoading,
    error: jobCommitmentsError,
  } = useJobCommitments();

  const {
    jobSettings,
    loading: jobSettingsLoading,
    error: jobSettingsError,
  } = useJobSettings();

  const { companySizes: companySizeObjects, loading: companySizesLoading, error: companySizesError } = useCompanySizes();

  /* --------------------- States --------------------- */

  const [selectedCompanies, setSelectedCompanies] = useState<Company[]>([]);
  const [selectedSpecialties, setSelectedSpecialties] = useState<
    CompanySpecialty[]
  >([]);
  const [selectedDepartments, setSelectedDepartments] = useState<Department[]>(
    []
  );
  const [selectedJobRoles, setSelectedJobRoles] = useState<JobRole[]>([]);
  const [selectedJobSettings, setSelectedJobSettings] = useState<JobSetting[]>(
    []
  );
  const [selectedJobCommitments, setSelectedJobCommitments] = useState<
    JobCommitment[]
  >([]);
  const [selectedDatePosted, setSelectedDatePosted] = useState<string | null>(
    null
  );
  const [selectedCompanySize, setSelectedCompanySize] = useState<CompanySize['id'][]>([]);

  /* --------------------- Constants --------------------- */

  const noMatchingResults = filteredJobPosts.length === 0;

  const currentlyLoading =
    loading ||
    domainsLoading ||
    departmentsLoading ||
    jobRolesLoading ||
    jobCommitmentsLoading ||
    jobSettingsLoading ||
    companySizesLoading;

  const errors =
    error ||
    domainsError ||
    departmentsError ||
    jobRolesError ||
    jobCommitmentsError ||
    jobSettingsError || 
    companySizesError;

  const uniqueCompanies: Company[] = Array.from(
    new Map(
      jobPosts.map((jobPost) => [jobPost.company.id, jobPost.company])
    ).values()
  );

  const uniqueSpecialties: CompanySpecialty[] = Array.from(
    new Map(
      jobPosts
        .flatMap((jobPost) => jobPost.company.company_specialties ?? [])
        .map((specialty) => [specialty.value, specialty])
    ).values()
  ).filter(Boolean);

  const uniqueJobRoles: JobRole[] = Array.from(
    jobPosts
      .reduce((map, jobPost) => {
        const jobRole = jobRoles.find(
          (role) => role.id === jobPost.job_role_id
        );
        if (jobRole && !map.has(jobRole.id)) {
          map.set(jobRole.id, jobRole);
        }
        return map;
      }, new Map<number, JobRole>())
      .values()
  );

  /* --------------------- Handles --------------------- */
  const filterJobPosts = () => {
    let filtered = [...jobPosts];

    if (selectedCompanies.length > 0) {
      filtered = filtered.filter((jobPost) =>
        selectedCompanies.some((company) => jobPost.company.id === company.id)
      );
    }

    if (selectedSpecialties.length > 0) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.company_specialties?.some((spec) =>
          selectedSpecialties.some(
            (selectedSpec) => selectedSpec.id === spec.id
          )
        )
      );
    }

    if (selectedDomains.length > 0) {
      filtered = filtered.filter((jobPost) =>
        jobPost.company.company_domains?.some((dom) =>
          selectedDomains.some(
            (selectedDomain) => selectedDomain.id === dom.healthcare_domain_id
          )
        )
      );
    }

    if (selectedDepartments.length > 0) {
      filtered = filtered.filter((jobPost) =>
        selectedDepartments.some((dept) => jobPost.department_id === dept.id)
      );
    }

    if (selectedJobRoles.length > 0) {
      filtered = filtered.filter((jobPost) =>
        selectedJobRoles.some((role) => jobPost.job_role_id === role.id)
      );
    }

    if (selectedJobSettings.length > 0) {
      filtered = filtered.filter((jobPost) =>
        selectedJobSettings.some(
          (setting) => jobPost.job_setting_id === setting.id
        )
      );
    }

    if (selectedJobCommitments.length > 0) {
      filtered = filtered.filter((jobPost) =>
        selectedJobCommitments.some(
          (commitment) => jobPost.job_commitment_id === commitment.id
        )
      );
    }

    if (selectedDatePosted) {
      const now = dayjs();

      filtered = filtered.filter((jobPost) => {
        const postDate = dayjs(jobPost.job_posted);

        switch (selectedDatePosted) {
          case 'Past 24 hours':
            return now.diff(postDate, 'hour') <= 24;
          case 'Past 3 days':
            return now.diff(postDate, 'day') <= 3;
          case 'Past week':
            return now.diff(postDate, 'day') <= 7;
          case 'Past month':
            return now.diff(postDate, 'day') <= 30;
          default:
            return true;
        }
      });
    }

    if (selectedCompanySize.length > 0) {
      filtered = filtered.filter(
        (jobPost) =>
          jobPost.company.company_size_id !== undefined &&
          selectedCompanySize.includes(jobPost.company.company_size_id)
      );
    }

    setFilteredJobPosts(filtered);
  };

  const resetFilters = () => {
    setSelectedCompanies([]);
    setSelectedSpecialties([]);
    setSelectedDomains([]);
    setSelectedDepartments([]);
    setSelectedJobRoles([]);
    setSelectedJobSettings([]);
    setSelectedJobCommitments([]);
    setSelectedCompanySize([]);
    setSelectedDatePosted(null);
  };

  const getNoResultsMessage = () => {
    const filters = [];

    if (selectedCompanies.length > 0) {
      filters.push(
        `for companies ${selectedCompanies.map((c) => c.company_name).join(', ')}`
      );
    }

    if (selectedSpecialties.length > 0) {
      filters.push(
        `with specialties ${selectedSpecialties.map((s) => s.value).join(', ')}`
      );
    }

    if (selectedDomains.length > 0) {
      filters.push(
        `in domains ${selectedDomains.map((d) => d.value).join(', ')}`
      );
    }

    if (selectedDepartments.length > 0) {
      filters.push(
        `in departments ${selectedDepartments.map((d) => d.dept_name).join(', ')}`
      );
    }

    if (selectedJobRoles.length > 0) {
      filters.push(
        `for job roles ${selectedJobRoles.map((r) => r.role_name).join(', ')}`
      );
    }

    if (selectedJobSettings.length > 0) {
      filters.push(
        `for job settings ${selectedJobSettings.map((s) => s.setting_name).join(', ')}`
      );
    }

    if (selectedJobCommitments.length > 0) {
      filters.push(
        `for job commitments ${selectedJobCommitments.map((c) => c.commitment_name).join(', ')}`
      );
    }

    if (selectedDatePosted) {
      filters.push(`posted in ${selectedDatePosted}`);
    }

    if (selectedCompanySize.length > 0) {
      const selectedSizeNames = selectedCompanySize
        .map((sizeId) => companySizeObjects.find((size) => size.id === sizeId)?.size_range)
        .filter((name): name is string => name !== undefined); // Filter out undefined values
    
      if (selectedSizeNames.length > 0) {
        filters.push(`for company size ${selectedSizeNames.join(', ')}`);
      }
    }

    let message = 'No matching job posts';

    if (filters.length > 0) {
      message += ` ${filters.join(', ')}.`;
    }

    return message;
  };
console.log({filteredJobPosts})
  /* --------------------- Lifecycle methods --------------------- */

  useEffect(() => {
    if (jobPosts.length > 0) {
      filterJobPosts();
    }
  }, [
    selectedCompanies,
    selectedSpecialties,
    selectedDomains,
    selectedDepartments,
    selectedJobRoles,
    selectedJobSettings,
    selectedJobCommitments,
    selectedDatePosted,
    selectedCompanySize,
    jobPosts,
  ]);

  const value = useMemo(() => {
    return {
      selectedCompanies,
      setSelectedCompanies,
      selectedDomains,
      setSelectedDomains,
      selectedSpecialties,
      setSelectedSpecialties,
      selectedDepartments,
      setSelectedDepartments,
      selectedJobRoles,
      setSelectedJobRoles,
      selectedJobSettings,
      setSelectedJobSettings,
      selectedJobCommitments,
      setSelectedJobCommitments,
      selectedDatePosted,
      setSelectedDatePosted,
      selectedCompanySize,
      setSelectedCompanySize,
      errors,
      currentlyLoading,
      uniqueCompanies,
      uniqueSpecialties,
      allDomains,
      domainsLoading,
      departments,
      departmentsLoading,
      uniqueJobRoles,
      jobRolesLoading,
      jobSettings,
      jobSettingsLoading,
      jobCommitments,
      jobCommitmentsLoading,
      companySizes: companySizeObjects,
      companySizesLoading,
      companySizesError,
      filteredJobPosts,
      resetFilters,
      noMatchingResults,
      getNoResultsMessage,
    };
  }, [
    selectedCompanies,
    selectedDomains,
    selectedSpecialties,
    selectedDepartments,
    selectedJobRoles,
    selectedJobSettings,
    selectedJobCommitments,
    selectedDatePosted,
    selectedCompanySize,
    errors,
    currentlyLoading,
    uniqueCompanies,
    uniqueSpecialties,
    allDomains,
    domainsLoading,
    departments,
    departmentsLoading,
    uniqueJobRoles,
    jobRolesLoading,
    jobSettings,
    jobSettingsLoading,
    jobCommitments,
    jobCommitmentsLoading,
    companySizeObjects,
    companySizesLoading,
    companySizesError,
    filteredJobPosts,
    noMatchingResults,
  ]);
  return (
    <FiltersContext.Provider value={value}>{children}</FiltersContext.Provider>
  );
}

export function useFiltersContext() {
  const context = useContext(FiltersContext);

  if (!context) {
    throw new Error('useFiltersContext must be used within a FiltersProvider');
  }

  return context;
}
