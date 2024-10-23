import { JobSettingEnum } from '@components/molecules/Filters/JobSettingEnum';

export interface JobSetting {
  id: number;
  setting_name: keyof typeof JobSettingEnum;
}
