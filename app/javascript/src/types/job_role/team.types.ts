import { useState, useEffect } from "react";
import { Adjudication } from "../adjudication.types";

const [teams, setTeams] = useState<string[]>([]);

useEffect(() => {
    const fetchTeams = async () => {
        try {
            const response = await fetch('/teams.json');
            if (!response.ok) {
                throw new Error(`Error fetching departments: ${response.status}`);
            }
            const data = await response.json();
            setTeams(data);
        } catch (error) {
            console.error(error);
        }
    };

    fetchTeams();
}, []);

export type Teams = typeof teams[number];

export interface Team {
    team_id: number;
    team_name: Teams;

    error_details: Adjudication['error_details'];
    reference_id: Adjudication['adjudicatable_id'];
    resolved: Adjudication['resolved'];
}