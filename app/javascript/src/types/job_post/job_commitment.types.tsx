import { useState, useEffect } from "react";
import { useJobCommitments } from "@hooks";

const [commitments, setCommitments] = useState<
  {
    id: number;
    commitment_name: string;
  }[]
>([]);

const { commitments: allCommitments } = useJobCommitments();

useEffect(() => {
  if (allCommitments) {
    setCommitments(allCommitments);
  }
}, [allCommitments]);

export type Commitments = (typeof commitments)[number];

export interface Commitment {
  id: Commitments["id"];
  commitment_name: Commitments["commitment_name"];
}
