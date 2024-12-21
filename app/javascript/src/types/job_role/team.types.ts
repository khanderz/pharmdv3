import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useTeams } from "@javascript/hooks";

const [teams, setTeams] = useState<
  {
    id: number;
    team_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { teams: allTeams } = useTeams();

useEffect(() => {
  if (allTeams) {
    setTeams(allTeams);
  }
}, [allTeams]);

export type Teams = (typeof teams)[number];

export interface Team extends Adjudicated {
  id: number;
  team_name: Teams["team_name"];
}
