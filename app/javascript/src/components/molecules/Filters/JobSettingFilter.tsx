import React from 'react';
import { Button } from '@components/atoms/index';
import { Typography } from '@mui/material';
import { JobSetting } from '@customtypes/job_post';

export type JobSettingFilterProps = {
  jobSettings: JobSetting[];
  selectedJobSettings: JobSetting[] | null;
  onJobSettingFilter: (jobSetting: JobSetting[] | null) => void;
  expanded?: boolean;
  resetJobSettingFilter: () => void;
};

export const JobSettingFilter = ({
  jobSettings,
  selectedJobSettings,
  onJobSettingFilter,
  expanded = false,
  resetJobSettingFilter,
}: JobSettingFilterProps) => {
  const remoteJobSetting = jobSettings.find(
    (jobSetting) => jobSetting.id === 5 // Remote
  );

  const handleJobSettingToggle = (jobSetting: JobSetting) => {
    const isSelected = (selectedJobSettings ?? []).some(
      (selected) => selected.id === jobSetting.id
    );

    if (isSelected) {
      onJobSettingFilter(
        (selectedJobSettings ?? []).filter(
          (selected) => selected.id !== jobSetting.id
        )
      );
    } else {
      onJobSettingFilter([...(selectedJobSettings ?? []), jobSetting]);
    }
  };

  return (
    <>
      <Typography variant="body1">Job Setting</Typography>

      {expanded
        ? jobSettings.map((jobSetting) => (
            <Button
              key={jobSetting.id}
              variant={
                (selectedJobSettings ?? []).some(
                  (selected) => selected.id === jobSetting.id
                )
                  ? 'contained'
                  : 'outlined'
              }
              fullWidth
              sx={{ my: 1 }}
              onClick={() => handleJobSettingToggle(jobSetting)}
            >
              {jobSetting.setting_name as string}
            </Button>
          ))
        : remoteJobSetting && (
            <Button
              key={remoteJobSetting.id}
              variant={
                (selectedJobSettings ?? []).some(
                  (selected) => selected.id === remoteJobSetting.id
                )
                  ? 'contained'
                  : 'outlined'
              }
              fullWidth
              sx={{ my: 1 }}
              onClick={() => handleJobSettingToggle(remoteJobSetting)}
            >
              {remoteJobSetting.setting_name as string}
            </Button>
          )}
    </>
  );
};
