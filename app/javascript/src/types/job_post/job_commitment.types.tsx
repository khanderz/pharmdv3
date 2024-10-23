export enum JobCommitmentEnum {
  CONTRACTOR = 'Contractor',
  FREELANCE = 'Freelance',
  FULL_TIME = 'Full-time',
  INTERNSHIP = 'Internship',
  PART_TIME = 'Part-time',
  PER_DIEM = 'Per Diem',
  TEMPORARY = 'Temporary',
  VOLUNTEER = 'Volunteer',
}

export interface JobCommitment {
  id: number;
  commitment_name: keyof typeof JobCommitmentEnum;
}
