export enum JobSettingEnum {
  FIELD_BASED = 'Field-based',
  FLEXIBLE = 'Flexible',
  HYBRID = 'Hybrid',
  ON_SITE = 'On-site',
  REMOTE = 'Remote',
}

export interface JobSetting {
  id: number;
  setting_name: keyof typeof JobSettingEnum;
}
