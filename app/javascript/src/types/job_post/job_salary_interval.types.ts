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
  id: number;
  interval: keyof typeof JobSalaryIntervalEnum;
}
