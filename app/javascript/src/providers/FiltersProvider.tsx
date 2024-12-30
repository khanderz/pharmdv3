import React, {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import {
  Company,
  CompanySize,
  CompanySpecialty,
  HealthcareDomain,
} from "@customtypes/company";
import {
  JobSetting,
  JobCommitment,
  JobPost,
  JobSalaryCurrency,
  Benefit,
  Credential,
  Education,
  Experience,
  Skill,
  Seniority,
} from "@customtypes/job_post";
import { Department, JobRole } from "@customtypes/job_role";
import {
  useJobPosts,
  useHealthcareDomains,
  useDepartments,
  useJobRoles,
  useJobCommitments,
  useJobSettings,
  useCompanySizes,
  useJobSalaryCurrencies,
  useCompanies,
  useBenefits,
  useCredentials,
  useEducations,
  useExperiences,
  useSeniorities,
  useSkills,
  useLocations,
} from "@hooks";
import dayjs from "dayjs";
import { AutocompleteOption } from "@components/atoms/Autocomplete";
import { Location } from "@javascript/types/locations.types";

interface FiltersContextProps {
  selectedCompanies: Company[];
  setSelectedCompanies: (companies: Company[]) => void;
  selectedDomains: HealthcareDomain[];
  setSelectedDomains: (domains: HealthcareDomain[]) => void;
  selectedSpecialties: CompanySpecialty[];
  setSelectedSpecialties: (specialties: CompanySpecialty[]) => void;
  selectedCompanySize: CompanySize[];
  setSelectedCompanySize: (size: CompanySize[]) => void;

  selectedJobRoles: JobRole[];
  setSelectedJobRoles: (jobRoles: JobRole[]) => void;
  selectedDepartments: Department[];
  setSelectedDepartments: (departments: Department[]) => void;

  selectedJobSettings: JobSetting[];
  setSelectedJobSettings: (jobSettings: JobSetting[]) => void;
  selectedJobCommitments: JobCommitment[];
  setSelectedJobCommitments: (jobCommitments: JobCommitment[]) => void;
  selectedDatePosted: string | null;
  setSelectedDatePosted: (datePosted: string) => void;

  selectedSalaryCurrency: Omit<
    JobSalaryCurrency,
    "error_details" | "reference_id" | "resolved"
  > | null;
  setSelectedSalaryCurrency: (
    currency: Omit<
      JobSalaryCurrency,
      "error_details" | "reference_id" | "resolved"
    >,
  ) => void;
  selectedSalaryRange: [number, number] | null;
  setSelectedSalaryRange: (range: [number, number] | null) => void;
  selectedBenefits: Benefit[];
  setSelectedBenefits: (benefits: Benefit[]) => void;
  selectedCredentials: Credential[];
  setSelectedCredentials: (credentials: Credential[]) => void;
  selectedEducations: Education[];
  setSelectedEducations: (educations: Education[]) => void;
  selectedExperiences: Experience[];
  setSelectedExperiences: (experiences: Experience[]) => void;
  selectedSeniorities: Seniority[];
  setSelectedSeniorities: (seniorities: Seniority[]) => void;
  selectedSkills: Skill[];
  setSelectedSkills: (skills: Skill[]) => void;
  selectedLocations: Location[];
  setSelectedLocations: (locations: Location[]) => void;

  errors: string | null;
  currentlyLoading: boolean;
  uniqueCompanies: Company[];
  uniqueSpecialties: CompanySpecialty[];
  allDomains: HealthcareDomain[];
  domainsLoading: boolean;
  domainsError: string | null;

  companySizes: CompanySize[];
  companySizesLoading: boolean;
  companySizesError: string | null;

  uniqueJobRoles: JobRole[];
  jobRolesLoading: boolean;
  jobRolesError: string | null;
  departments: Department[];
  departmentsLoading: boolean;
  departmentError: string | null;

  jobSettings: JobSetting[];
  jobSettingsLoading: boolean;
  jobSettingsError: string | null;
  jobCommitments: JobCommitment[];
  jobCommitmentsLoading: boolean;
  jobCommitmentsError: string | null;
  currencies: JobSalaryCurrency[];
  currenciesLoading: boolean;
  currenciesError: string | null;
  benefits: Benefit[];
  benefitsLoading: boolean;
  benefitsError: string | null;
  credentials: Credential[];
  credentialsLoading: boolean;
  credentialsError: string | null;
  educations: Education[];
  educationsLoading: boolean;
  educationsError: string | null;
  experiences: Experience[];
  experiencesLoading: boolean;
  experiencesError: string | null;
  seniorities: Seniority[];
  senioritiesLoading: boolean;
  senioritiesError: string | null;
  skills: Skill[];
  skillsLoading: boolean;
  skillsError: string | null;
  uniqueLocations: Location[];
  locationsLoading: boolean;
  locationsError: string | null;

  filteredJobPosts: JobPost[];
  resetFilters: () => void;
  noMatchingResults: boolean;
  getNoResultsMessage?: () => string;
  setFilteredJobPosts: (jobPosts: JobPost[]) => void;

  searchQuery: string;
  setSearchQuery: (query: string) => void;

  filteredCompanies: Company[];
  setFilteredCompanies: (companies: Company[]) => void;
  filterCompanies: () => void;
  companiesLoading: boolean;
  companiesError: string | null;
}

export const FiltersContext = createContext<FiltersContextProps>({
  selectedCompanies: [],
  setSelectedCompanies: () => {},
  selectedCompanySize: [],
  setSelectedCompanySize: () => {},
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
  selectedDatePosted: "",
  setSelectedDatePosted: () => {},
  selectedSalaryCurrency: null,
  setSelectedSalaryCurrency: () => {},
  selectedSalaryRange: null,
  setSelectedSalaryRange: () => {},
  selectedBenefits: [],
  setSelectedBenefits: () => {},
  selectedCredentials: [],
  setSelectedCredentials: () => {},
  selectedEducations: [],
  setSelectedEducations: () => {},
  selectedExperiences: [],
  setSelectedExperiences: () => {},
  selectedSeniorities: [],
  setSelectedSeniorities: () => {},
  selectedSkills: [],
  setSelectedSkills: () => {},
  selectedLocations: [],
  setSelectedLocations: () => {},

  errors: null,
  currentlyLoading: false,
  uniqueCompanies: [],
  uniqueSpecialties: [],
  allDomains: [],
  domainsLoading: false,
  companySizes: [],
  companySizesLoading: false,
  companySizesError: null,

  departments: [],
  departmentsLoading: false,
  uniqueJobRoles: [],
  jobRolesLoading: false,

  jobSettings: [],
  jobSettingsLoading: false,
  jobCommitments: [],
  jobCommitmentsLoading: false,
  currencies: [],
  currenciesLoading: false,
  currenciesError: null,
  benefits: [],
  benefitsLoading: false,
  benefitsError: null,
  credentials: [],
  credentialsLoading: false,
  credentialsError: null,
  educations: [],
  educationsLoading: false,
  educationsError: null,
  experiences: [],
  experiencesLoading: false,
  experiencesError: null,
  seniorities: [],
  senioritiesLoading: false,
  senioritiesError: null,
  skills: [],
  skillsLoading: false,
  skillsError: null,
  uniqueLocations: [],
  locationsLoading: false,
  locationsError: null,

  filteredJobPosts: [],
  resetFilters: () => {},
  noMatchingResults: false,
  getNoResultsMessage: () => "",
  setFilteredJobPosts: () => {},

  searchQuery: "",
  setSearchQuery: () => {},

  filteredCompanies: [],
  setFilteredCompanies: () => {},
  filterCompanies: () => {},
  companiesLoading: false,
  companiesError: null,
} as FiltersContextProps);

interface FiltersProviderProps {
  children: React.ReactNode;
}

export const MIN_SALARY = 0;
export const MAX_SALARY = 300000;

export function FiltersProvider({ children }: FiltersProviderProps) {
  const [selectedDomains, setSelectedDomains] = useState<HealthcareDomain[]>(
    [],
  );

  const domainIds = useMemo(() => {
    return selectedDomains.length > 0
      ? selectedDomains.map(domain => domain.id)
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

  const {
    companySizes: companySizeObjects,
    loading: companySizesLoading,
    error: companySizesError,
  } = useCompanySizes();

  const {
    jobSalaryCurrencies: allCurrencies,
    loading: currenciesLoading,
    error: currenciesError,
  } = useJobSalaryCurrencies();

  const {
    benefits,
    loading: benefitsLoading,
    error: benefitsError,
  } = useBenefits();

  const {
    credentials,
    loading: credentialsLoading,
    error: credentialsError,
  } = useCredentials();

  const {
    educations,
    loading: educationsLoading,
    error: educationsError,
  } = useEducations();

  const {
    experiences,
    loading: experiencesLoading,
    error: experiencesError,
  } = useExperiences();

  const {
    seniorities,
    loading: senioritiesLoading,
    error: senioritiesError,
  } = useSeniorities();

  const { skills, loading: skillsLoading, error: skillsError } = useSkills();

  const {
    locations,
    loading: locationsLoading,
    error: locationsError,
  } = useLocations();

  /* --------------------- States --------------------- */

  const [selectedCompanies, setSelectedCompanies] = useState<Company[]>([]);
  const [selectedSpecialties, setSelectedSpecialties] = useState<
    CompanySpecialty[]
  >([]);
  const [selectedDepartments, setSelectedDepartments] = useState<Department[]>(
    [],
  );
  const [selectedJobRoles, setSelectedJobRoles] = useState<JobRole[]>([]);
  const [selectedJobSettings, setSelectedJobSettings] = useState<JobSetting[]>(
    [],
  );
  const [selectedJobCommitments, setSelectedJobCommitments] = useState<
    JobCommitment[]
  >([]);
  const [selectedDatePosted, setSelectedDatePosted] = useState<string | null>(
    null,
  );
  const [selectedCompanySize, setSelectedCompanySize] = useState<CompanySize[]>(
    [],
  );
  const [selectedSalaryCurrency, setSelectedSalaryCurrency] =
    useState<
      Omit<JobSalaryCurrency, "error_details" | "reference_id" | "resolved">
    >("");
  const [selectedSalaryRange, setSelectedSalaryRange] = useState<
    [number, number]
  >([MIN_SALARY, MAX_SALARY]);
  const [selectedLocation, setSelectedLocation] =
    useState<AutocompleteOption>();
  const [searchQuery, setSearchQuery] = useState<string>("");

  const [selectedBenefits, setSelectedBenefits] = useState<Benefit[]>([]);
  const [selectedCredentials, setSelectedCredentials] = useState<Credential[]>(
    [],
  );
  const [selectedEducations, setSelectedEducations] = useState<Education[]>([]);
  const [selectedExperiences, setSelectedExperiences] = useState<Experience[]>(
    [],
  );
  const [selectedSeniorities, setSelectedSeniorities] = useState<Seniority[]>(
    [],
  );
  const [selectedSkills, setSelectedSkills] = useState<Skill[]>([]);
  const [selectedLocations, setSelectedLocations] = useState<Location[]>([]);

  /* --------------------- Constants --------------------- */
  const companyFilters = useMemo(() => {
    const filters: any = {};

    if (selectedDomains.length > 0) {
      filters.domain_id = selectedDomains.map(domain => domain.id);
    }
    if (selectedCompanySize.length > 0) {
      filters.company_size_id = selectedCompanySize.map(size => size.id);
    }
    if (selectedSpecialties.length > 0) {
      filters.specialization_id = selectedSpecialties.map(spec => spec.id);
    }

    return filters;
  }, [
    selectedDomains,
    selectedCompanySize,
    selectedSpecialties,
    selectedLocation,
  ]);

  const {
    companies,
    filteredCompanies,
    setFilteredCompanies,
    loading: companiesLoading,
    error: companiesError,
  } = useCompanies(companyFilters);

  const noMatchingResults = filteredJobPosts.length === 0;

  const currentlyLoading =
    loading ||
    domainsLoading ||
    departmentsLoading ||
    jobRolesLoading ||
    jobCommitmentsLoading ||
    jobSettingsLoading ||
    companySizesLoading ||
    currenciesLoading ||
    companiesLoading ||
    benefitsLoading ||
    credentialsLoading ||
    educationsLoading ||
    experiencesLoading ||
    senioritiesLoading ||
    skillsLoading ||
    locationsLoading;

  const errors =
    error ||
    domainsError ||
    departmentsError ||
    jobRolesError ||
    jobCommitmentsError ||
    jobSettingsError ||
    companySizesError ||
    currenciesError ||
    companiesError ||
    benefitsError ||
    credentialsError ||
    educationsError ||
    experiencesError ||
    senioritiesError ||
    skillsError ||
    locationsError;

  const uniqueCompanies: Company[] = Array.from(
    new Map(
      jobPosts.map(jobPost => [jobPost.company.id, jobPost.company]),
    ).values(),
  );

  const uniqueSpecialties: CompanySpecialty[] = Array.from(
    new Map(
      jobPosts
        .flatMap(jobPost => jobPost.company.company_specialties ?? [])
        .map(specialty => [specialty.value, specialty]),
    ).values(),
  ).filter(Boolean);

  const uniqueJobRoles: JobRole[] = Array.from(
    jobPosts
      .reduce((map, jobPost) => {
        const jobRole = jobRoles.find(role => role.id === jobPost.job_role_id);
        if (jobRole && !map.has(jobRole.id)) {
          map.set(jobRole.id, jobRole);
        }
        return map;
      }, new Map<number, JobRole>())
      .values(),
  );

  const uniqueLocations: Location[] = useMemo(() => {
    const locationMap = new Map<number, Location>();

    jobPosts.forEach(jobPost => {
      if (
        jobPost.job_post_locations &&
        Array.isArray(jobPost.job_post_locations)
      ) {
        jobPost.job_post_locations.forEach(jobPostLocation => {
          const location = locations.find(
            loc => loc.id === jobPostLocation.location_id,
          );
          if (location) {
            locationMap.set(location.id, location);
          }
        });
      }
    });

    return Array.from(locationMap.values());
  }, [jobPosts, locations]);

  /* --------------------- Handles --------------------- */
  const filterCompanies = () => {
    let filtered = [...companies];

    if (searchQuery) {
      const lowerQuery = searchQuery.toLowerCase();
      filtered = filtered.filter(company =>
        company.company_name.toLowerCase().includes(lowerQuery),
      );
    }

    setFilteredCompanies(filtered);
  };

  const filterJobPosts = () => {
    let filtered = [...jobPosts];

    if (selectedCompanies.length > 0) {
      filtered = filtered.filter(jobPost =>
        selectedCompanies.some(company => jobPost.company.id === company.id),
      );
    }

    if (selectedSpecialties.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.company.company_specialties?.some(spec =>
          selectedSpecialties.some(selectedSpec => selectedSpec.id === spec.id),
        ),
      );
    }

    if (selectedDomains.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.company.company_domains?.some(dom =>
          selectedDomains.some(
            selectedDomain => selectedDomain.id === dom.healthcare_domain_id,
          ),
        ),
      );
    }

    if (selectedDepartments.length > 0) {
      filtered = filtered.filter(jobPost =>
        selectedDepartments.some(dept => jobPost.department_id === dept.id),
      );
    }

    if (selectedJobRoles.length > 0) {
      filtered = filtered.filter(jobPost =>
        selectedJobRoles.some(role => jobPost.job_role_id === role.id),
      );
    }

    if (selectedJobSettings.length > 0) {
      filtered = filtered.filter(jobPost =>
        selectedJobSettings.some(
          setting => jobPost.job_setting_id === setting.id,
        ),
      );
    }

    if (selectedJobCommitments.length > 0) {
      filtered = filtered.filter(jobPost =>
        selectedJobCommitments.some(
          commitment => jobPost.job_commitment_id === commitment.id,
        ),
      );
    }

    if (selectedDatePosted) {
      const now = dayjs();

      filtered = filtered.filter(jobPost => {
        const postDate = dayjs(jobPost.job_posted);

        if (!postDate.isValid()) {
          console.warn("Invalid job_posted date:", jobPost.job_posted);
          return false;
        }

        switch (selectedDatePosted) {
          case "Past 24 hours":
            return now.diff(postDate, "hour") <= 24;
          case "Past 3 days":
            return now.diff(postDate, "day") <= 3;
          case "Past week":
            return now.diff(postDate, "day") <= 7;
          case "Past month":
            return now.diff(postDate, "day") <= 30;
          default:
            return true;
        }
      });
    }

    if (selectedCompanySize.length > 0) {
      filtered = filtered.filter(
        jobPost =>
          jobPost.company.company_size_id !== undefined &&
          selectedCompanySize
            .map(size => size.id)
            .includes(jobPost.company.company_size_id),
      );
    }

    if (selectedSalaryRange) {
      const [min, max] = selectedSalaryRange;
      filtered = filtered.filter(
        jobPost =>
          jobPost.job_salary_min >= min && jobPost.job_salary_max <= max,
      );
    }

    if (selectedSalaryCurrency) {
      filtered = filtered.filter(
        jobPost => jobPost.job_salary_currency_id === selectedSalaryCurrency.id,
      );
    }

    if (selectedSalaryRange) {
      const [minSalary, maxSalary] = selectedSalaryRange;
      filtered = filtered.filter(jobPost => {
        const salaryMin = jobPost.job_salary_min || MIN_SALARY;
        const salaryMax = jobPost.job_salary_max || MAX_SALARY;
        return (
          salaryMin >= minSalary &&
          salaryMax <= maxSalary &&
          (!selectedSalaryCurrency ||
            jobPost.job_salary_currency_id === selectedSalaryCurrency.id)
        );
      });
    }

    if (selectedLocations.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.job_post_locations?.some(jpl =>
          selectedLocations.some(
            selectedLocation =>
              Number(selectedLocation.key) === jpl.location_id,
          ),
        ),
      );
    }

    if (searchQuery) {
      const lowerQuery = searchQuery.toLowerCase();
      filtered = filtered.filter(jobPost => {
        const fieldsToSearch = [
          jobPost.job_title,
          jobPost.job_description,
          jobPost.job_additional,
          jobPost.company.company_name,
          ...(Array.isArray(jobPost.job_locations)
            ? jobPost.job_locations
            : [jobPost.job_locations]),
        ];

        return fieldsToSearch.some(
          field => field && field.toLowerCase().includes(lowerQuery),
        );
      });
    }

    if (selectedBenefits.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.job_post_benefits?.some(benefit =>
          selectedBenefits.some(
            selectedBenefit => selectedBenefit.id === benefit.benefit_id,
          ),
        ),
      );
    }

    if (selectedCredentials.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.job_post_credentials?.some(credential =>
          selectedCredentials.some(
            selectedCredential =>
              selectedCredential.id === credential.credential_id,
          ),
        ),
      );
    }

    if (selectedEducations.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.job_post_educations?.some(education =>
          selectedEducations.some(
            selectedEducation =>
              selectedEducation.id === education.education_id,
          ),
        ),
      );
    }

    if (selectedExperiences.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.job_post_experiences?.some(experience =>
          selectedExperiences.some(
            selectedExperience =>
              selectedExperience.id === experience.experience_id,
          ),
        ),
      );
    }

    if (selectedSeniorities.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.job_post_seniorities?.some(seniority =>
          selectedSeniorities.some(
            selectedSeniority =>
              selectedSeniority.id === seniority.seniority_id,
          ),
        ),
      );
    }

    if (selectedSkills.length > 0) {
      filtered = filtered.filter(jobPost =>
        jobPost.job_post_skills?.some(skill =>
          selectedSkills.some(
            selectedSkill => selectedSkill.id === skill.skill_id,
          ),
        ),
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
    setSelectedSalaryCurrency("");
    setSelectedSalaryRange([MIN_SALARY, MAX_SALARY]);
    setSearchQuery("");
    setSelectedBenefits([]);
    setSelectedCredentials([]);
    setSelectedEducations([]);
    setSelectedExperiences([]);
    setSelectedSeniorities([]);
    setSelectedSkills([]);
    setSelectedLocations([]);
  };

  const getNoResultsMessage = () => {
    const filters = [];

    if (selectedCompanies.length > 0) {
      filters.push(
        `for companies ${selectedCompanies.map(c => c.company_name).join(", ")}`,
      );
    }

    if (selectedSpecialties.length > 0) {
      filters.push(
        `with specialties ${selectedSpecialties.map(s => s.value).join(", ")}`,
      );
    }

    if (selectedDomains.length > 0) {
      filters.push(
        `in domains ${selectedDomains.map(d => d.value).join(", ")}`,
      );
    }

    if (selectedDepartments.length > 0) {
      filters.push(
        `in departments ${selectedDepartments.map(d => d.dept_name).join(", ")}`,
      );
    }

    if (selectedJobRoles.length > 0) {
      filters.push(
        `for job roles ${selectedJobRoles.map(r => r.role_name).join(", ")}`,
      );
    }

    if (selectedJobSettings.length > 0) {
      filters.push(
        `for job settings ${selectedJobSettings.map(s => s.setting_name).join(", ")}`,
      );
    }

    if (selectedJobCommitments.length > 0) {
      filters.push(
        `for job commitments ${selectedJobCommitments.map(c => c.commitment_name).join(", ")}`,
      );
    }

    if (selectedDatePosted) {
      filters.push(`posted in ${selectedDatePosted}`);
    }

    if (selectedCompanySize.length > 0) {
      const selectedSizeNames = selectedCompanySize.map(
        size =>
          companySizeObjects.find(s => s.id === size.id)?.size_range ?? "",
      );

      if (selectedSizeNames.length > 0) {
        filters.push(`for company size ${selectedSizeNames.join(", ")}`);
      }
    }

    if (selectedSalaryRange) {
      filters.push(
        `with salary range between ${selectedSalaryRange[0]} and ${selectedSalaryRange[1]}`,
      );
    }

    if (selectedSalaryCurrency) {
      filters.push(
        `with salary currency ${selectedSalaryCurrency.currency_code}`,
      );
    }

    if (selectedLocations.length > 0) {
      filters.push(
        `in locations ${selectedLocations.map(loc => loc.value).join(", ")}`,
      );
    }

    if (searchQuery) {
      filters.push(`with search query ${searchQuery}`);
    }

    if (selectedBenefits.length > 0) {
      filters.push(
        `with benefits ${selectedBenefits.map(b => b.benefit_name).join(", ")}`,
      );
    }

    if (selectedCredentials.length > 0) {
      filters.push(
        `with credentials ${selectedCredentials.map(c => c.credential_name).join(", ")}`,
      );
    }

    if (selectedEducations.length > 0) {
      filters.push(
        `with educations ${selectedEducations.map(e => e.education_name).join(", ")}`,
      );
    }

    if (selectedExperiences.length > 0) {
      filters.push(
        `with experiences ${selectedExperiences.map(e => e.experience_name).join(", ")}`,
      );
    }

    if (selectedSeniorities.length > 0) {
      filters.push(
        `with seniorities ${selectedSeniorities.map(s => s.seniority_name).join(", ")}`,
      );
    }

    if (selectedSkills.length > 0) {
      filters.push(
        `with skills ${selectedSkills.map(s => s.skill_name).join(", ")}`,
      );
    }

    let message = "No matching job posts";
    if (filters.length > 0) {
      message += ` ${filters.join(", ")}.`;
    }

    return message;
  };

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
    selectedSalaryCurrency,
    selectedSalaryRange,
    searchQuery,
    jobPosts,
    selectedBenefits,
    selectedCredentials,
    selectedEducations,
    selectedExperiences,
    selectedSeniorities,
    selectedSkills,
    selectedLocations,
  ]);

  useEffect(() => {
    filterCompanies();
  }, [companies, searchQuery]);

  const value = useMemo(() => {
    return {
      selectedCompanies,
      setSelectedCompanies,
      selectedDomains,
      setSelectedDomains,
      selectedSpecialties,
      setSelectedSpecialties,
      selectedCompanySize,
      setSelectedCompanySize,

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
      selectedSalaryCurrency,
      setSelectedSalaryCurrency,
      selectedSalaryRange,
      setSelectedSalaryRange,
      selectedBenefits,
      setSelectedBenefits,
      selectedCredentials,
      setSelectedCredentials,
      selectedEducations,
      setSelectedEducations,
      selectedExperiences,
      setSelectedExperiences,
      selectedSeniorities,
      setSelectedSeniorities,
      selectedSkills,
      setSelectedSkills,
      selectedLocations,
      setSelectedLocations,

      errors,
      currentlyLoading,
      uniqueCompanies,
      uniqueSpecialties,
      allDomains,
      domainsLoading,
      companySizes: companySizeObjects,
      companySizesLoading,
      companySizesError,

      departments,
      departmentsLoading,
      uniqueJobRoles,
      jobRolesLoading,

      jobSettings,
      jobSettingsLoading,
      jobCommitments,
      jobCommitmentsLoading,
      currencies: allCurrencies,
      currenciesLoading,
      currenciesError,
      filteredJobPosts,
      setFilteredJobPosts,

      resetFilters,
      noMatchingResults,
      getNoResultsMessage,

      searchQuery,
      setSearchQuery,

      filteredCompanies,
      setFilteredCompanies,
      filterCompanies,
      companiesLoading,
      companiesError,

      benefits,
      credentials,
      educations,
      experiences,
      seniorities,
      skills,
      uniqueLocations,
    };
  }, [
    selectedCompanies,
    selectedDomains,
    selectedSpecialties,
    selectedCompanySize,

    selectedDepartments,
    selectedJobRoles,
    selectedJobSettings,
    selectedJobCommitments,
    selectedDatePosted,
    selectedSalaryCurrency,
    selectedSalaryRange,
    selectedBenefits,
    selectedCredentials,
    selectedEducations,
    selectedExperiences,
    selectedSeniorities,
    selectedSkills,
    uniqueLocations,
    selectedLocations,

    errors,
    currentlyLoading,
    uniqueCompanies,
    uniqueSpecialties,
    allDomains,
    domainsLoading,
    companySizeObjects,
    companySizesLoading,
    companySizesError,

    departments,
    departmentsLoading,
    uniqueJobRoles,
    jobRolesLoading,

    jobSettings,
    jobSettingsLoading,
    jobCommitments,
    jobCommitmentsLoading,
    allCurrencies,
    currenciesLoading,
    currenciesError,

    filteredJobPosts,
    noMatchingResults,

    filteredCompanies,
    filterCompanies,
    companiesLoading,
    companiesError,
  ]);

  return (
    <FiltersContext.Provider value={value}>{children}</FiltersContext.Provider>
  );
}

export function useFiltersContext() {
  const context = useContext(FiltersContext);

  if (!context) {
    throw new Error("useFiltersContext must be used within a FiltersProvider");
  }

  return context;
}
