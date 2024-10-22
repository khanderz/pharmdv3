import React from 'react';
import { Button } from '@components/atoms/index';
import { JobSetting } from '@customtypes/job_post';
import { Typography } from '@mui/material';

export type JobSettingFilterProps = {
  jobSettings: JobSetting[];
  selectedJobSetting: JobSetting | null;
  onJobSettingFilter: (jobSetting: JobSetting | null) => void;
};

export const JobSettingFilter = ({
  jobSettings,
  selectedJobSetting,
  onJobSettingFilter,
}: JobSettingFilterProps) => {
  return (
    <>
      <Typography variant="body1">Job Setting</Typography>
      {jobSettings.map((jobSetting) => (
        <Button
          key={jobSetting.id}
          variant="outlined"
          fullWidth
          sx={{ my: 1 }}
          onClick={() => onJobSettingFilter(jobSetting)}
        >
          {jobSetting.setting_name}
        </Button>
      ))}
    </>
  );
};
