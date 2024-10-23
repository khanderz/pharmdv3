import React from 'react';
import { Button } from '@components/atoms/index';
import { Typography } from '@mui/material';
import { JobSetting } from '@customtypes/job_post';

export type JobSettingFilterProps = {
  jobSettings: JobSetting[];
  selectedJobSetting: JobSetting | null;
  onJobSettingFilter: (jobSetting: JobSetting | null) => void;
  expanded?: boolean;
};

export const JobSettingFilter = ({
  jobSettings,
  selectedJobSetting,
  onJobSettingFilter,
  expanded = false,
}: JobSettingFilterProps) => {
  const remoteJobSetting = jobSettings.find(
    (jobSetting) => jobSetting.id === 5 // Remote
  );

  return (
    <>
      <Typography variant="body1">Job Setting</Typography>

      {expanded
        ? jobSettings.map((jobSetting) => (
            <Button
              key={jobSetting.id}
              variant={
                selectedJobSetting?.id === jobSetting.id
                  ? 'contained'
                  : 'outlined'
              }
              fullWidth
              sx={{ my: 1 }}
              onClick={() => onJobSettingFilter(jobSetting)}
            >
              {jobSetting.setting_name}
            </Button>
          ))
        : remoteJobSetting && (
            <Button
              key={remoteJobSetting.id}
              variant={
                selectedJobSetting?.id === remoteJobSetting.id
                  ? 'contained'
                  : 'outlined'
              }
              fullWidth
              sx={{ my: 1 }}
              onClick={() => onJobSettingFilter(remoteJobSetting)}
            >
              {remoteJobSetting.setting_name}
            </Button>
          )}
    </>
  );
};
