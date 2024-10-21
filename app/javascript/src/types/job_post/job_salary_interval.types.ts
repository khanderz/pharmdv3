export enum JobSalaryIntervalEnum {
    ANNUALLY = 'Annually',
    BI_WEEKLY = 'Bi-weekly',
    DAILY = 'Daily',
    HOURLY = 'Hourly',
    MONTHLY = 'Monthly',
    QUARTERLY = 'Quarterly',
    WEEKLY = 'Weekly',
}

export interface JobSalaryInterval {
    job_salary_interval_id: number;
    key: keyof typeof JobSalaryIntervalEnum;
    interval: typeof JobSalaryIntervalEnum[keyof typeof JobSalaryIntervalEnum];
}