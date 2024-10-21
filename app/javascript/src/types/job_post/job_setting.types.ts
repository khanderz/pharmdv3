export enum JobSettingEnum {
    FIELD_BASED = 'Field-based',
    FLEXIBLE = 'Flexible',
    HYBRID = 'Hybrid',
    ON_SITE = 'On-site',
    REMOTE = 'Remote',
}

export interface JobSetting {
    id: number;
    job_setting_key: keyof typeof JobSettingEnum;
    job_setting_name: typeof JobSettingEnum[keyof typeof JobSettingEnum];
}