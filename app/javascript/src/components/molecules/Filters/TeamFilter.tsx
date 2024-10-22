import React from 'react';
import { Select } from '@components/atoms/index';
import { MenuItem } from '@mui/material';
import { Team } from '@customtypes/job_role';

export type TeamFilterProps = {
  teams: Team[];
  selectedTeam: Team | null;
  onTeamFilter: (team: Team | null) => void;
};

export const TeamFilter = ({
  teams,
  selectedTeam,
  onTeamFilter,
}: TeamFilterProps) => {
  return (
    <Select
      inputLabel="Team"
      value={selectedTeam?.id || ''}
      onChange={(e) => {
        const team = teams.find((team) => team.id === e.target.value);
        onTeamFilter(team || null);
      }}
    >
      {teams.map((team) => (
        <MenuItem key={team.id} value={team.id}>
          {team.team_name}
        </MenuItem>
      ))}
    </Select>
  );
};
