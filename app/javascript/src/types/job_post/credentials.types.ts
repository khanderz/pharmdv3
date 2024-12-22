import { useState, useEffect } from "react";
import { Adjudicated } from "../adjudication.types";
import { useCredentials } from "@hooks";

const [credentials, setCredentials] = useState<
  {
    id: number;
    credential_code: string;
    credential_name: string;
    error_details: Adjudicated["error_details"];
    reference_id: Adjudicated["reference_id"];
    resolved: Adjudicated["resolved"];
  }[]
>([]);

const { credentials: allCredentials } = useCredentials();

useEffect(() => {
  if (allCredentials) {
    setCredentials(allCredentials);
  }
}, [allCredentials]);

export type Credentials = (typeof credentials)[number];

export interface Credential extends Adjudicated {
  id: Credentials["id"];
  credential_code: Credentials["credential_code"];
  credential_name: Credentials["credential_name"];
}
